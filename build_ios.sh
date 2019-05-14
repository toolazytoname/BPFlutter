#! /bin/bash

BUILD_MODE="debug"
ARCHS_ARM="arm64,armv7"
FLUTTER_ROOT=".flutter"
TARGET_PATH="lib/main.dart"
PRODUCT_DIR="product"
PRODUCT_ZIP="product.zip"

BUILD_PATH="iosbp/build_ios/${BUILD_MODE}"
PRODUCT_PATH="${BUILD_PATH}/${PRODUCT_DIR}"
PRODUCT_APP_PATH="${PRODUCT_PATH}/Flutter"
# git repository path
PRODUCT_GIT_DIR="../"

usage() {
    echo
    echo "build_ios.sh [-h | [-m <build_mode>] [-s]]"
    echo ""
    echo "-h    - Help."
    echo "-m    - Build model, valid values are 'debug', 'profile', or 'release'. "
    echo "        Default values: 'debug'."
    echo ""
    echo "Build product in 'build_ios/<builde_model>/${PRODUCT_DIR}' directory."
    echo
}

EchoError() {
    echo "$@" 1>&2
}

flutter_get_packages() {
    echo "================================="
    echo "Start get flutter app plugin"

    local flutter_wrapper="./flutterw"
    if [ -e $flutter_wrapper ]; then
        echo 'flutterw installed' >/dev/null
    else
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/passsy/flutter_wrapper/master/install.sh)"
        if [[ $? -ne 0 ]]; then
            EchoError "Failed to installed flutter_wrapper."
            exit -1
        fi

    fi

    ${flutter_wrapper} packages get --verbose
    if [[ $? -ne 0 ]]; then
        EchoError "Failed to install flutter plugins."
        exit -1
    fi

    echo "Finish get flutter app plugin"
}
build_flutter_app() {
  local artifact_variant="unknown"
     case "$BUILD_MODE" in
     release*)
         artifact_variant="ios-release"
         ;;
     profile*)
         artifact_variant="ios-profile"
         ;;
     debug*)
         artifact_variant="ios"
         ;;
     *)
         EchoError "========================================================================"
         EchoError "ERROR: Unknown FLUTTER_BUILD_MODE: ${BUILD_MODE}."
         EchoError "Valid values are 'debug', 'profile', or 'release'."
         EchoError "This is controlled by the -m environment varaible."
         EchoError "========================================================================"
         exit -1
         ;;
     esac
  # fLutter clean
  ${FLUTTER_ROOT}/bin/flutter clean
  #在iOS9上会有诡异的崩溃，把build aot，build bundle 替换成${FLUTTER_ROOT}/bin/flutter build ios
  #https://github.com/flutter/flutter/issues/30834
  ${FLUTTER_ROOT}/bin/flutter build ios
  if [[ $? -ne 0 ]]; then
      EchoError "flutter build ios"
      exit -1
  fi

  # copy flutter sdk ,asset-dir 移到了 App.framework 里面，所以把这段代码移到 build bundle 后面
  local framework_path="${FLUTTER_ROOT}/bin/cache/artifacts/engine/${artifact_variant}"
  local flutter_framework="${framework_path}/Flutter.framework"
  local flutter_podspec="${framework_path}/Flutter.podspec"

  mkdir -p  ${PRODUCT_APP_PATH}
  cp -r -- "ios/Flutter/App.framework" "${PRODUCT_APP_PATH}"
  cp -r -- "${flutter_framework}" "${PRODUCT_APP_PATH}"
  cp -r -- "${flutter_podspec}" "${PRODUCT_APP_PATH}"

  if [[ "$BUILD_MODE" != "debug" ]]; then
    #Release环境删除Flutter.framework "x86_64" 框架
    lipo -remove "x86_64" "${PRODUCT_APP_PATH}/Flutter.framework/Flutter" -output "${PRODUCT_APP_PATH}/Flutter.framework/Flutter"
  fi

  echo "Finish build flutter app"
}


flutter_copy_packages() {
    echo "================================="
    echo "Start copy flutter app plugin"

    local flutter_plugin_registrant="FlutterPluginRegistrant"

    cp -f "ios/Runner/GeneratedPluginRegistrant.h" "${PRODUCT_PATH}/GeneratedPluginRegistrant.h"
    cp -f "ios/Runner/GeneratedPluginRegistrant.m" "${PRODUCT_PATH}/GeneratedPluginRegistrant.m"

#改造
#SharedPreferencesPlugin.m 文件中去掉尖括号
#import <shared_preferences/SharedPreferencesPlugin.h>
#替换为
#import "SharedPreferencesPlugin.h"
#

    sed -i '' -e 's/<.*\/\(.*\)>/\"\1\"/g' ${PRODUCT_PATH}/GeneratedPluginRegistrant.m

    local flutter_plugin=".flutter-plugins"
    if [ -e $flutter_plugin ]; then
        OLD_IFS="$IFS"
        IFS="="
        cat ${flutter_plugin} | while read plugin; do
            local plugin_info=($plugin)
            local plugin_name=${plugin_info[0]}
            local plugin_path=${plugin_info[1]}

            if [ -e ${plugin_path} ]; then
                local plugin_path_ios="${plugin_path}ios"
                if [ -e ${plugin_path_ios} ]; then
                    if [ -s ${plugin_path_ios} ]; then
                        echo "copy plugin 'plugin_name' from '${plugin_path_ios}' to '${PRODUCT_PATH}/${plugin_name}'"
                        cp -rf ${plugin_path_ios} "${PRODUCT_PATH}/${plugin_name}"
                    fi
                fi
            fi
        done
        IFS="$OLD_IFS"
    fi
    echo "Finish copy flutter app plugin"
}


function travFolder()
{
  for file in `ls $1`
  do
    local path=$1"/"$file
    if [ -d $path ]
     then
      # 跳过framework
      if [ "${path##*.}" != "framework" ]; then
        travFolder $path
      fi
    else
      add_compile_condition $path
    fi
  done
}

function add_compile_condition() {
  filename=$1
  if [ "${filename##*.}" = "h" -o "${filename##*.}" = "m" ]; then
    echo "add compile condition in file $1"
    # sed -i '1 #if !TARGET_OS_SIMULATOR' - $1
    echo -e "#if !TARGET_OS_SIMULATOR\n`cat $1`" >$1
    echo "#endif">>$1
  fi
}

start_build() {
    rm -rf ${BUILD_PATH}

    flutter_get_packages

    build_flutter_app

    flutter_copy_packages

    travFolder ${PRODUCT_PATH}

    echo ""
    echo "done!"
}

show_help=0
while getopts "m:sh" arg; do
    case $arg in
    m)
        BUILD_MODE="$OPTARG"
        ;;
    h)
        show_help=1
        ;;
    ?)
        show_help=1
        ;;
    esac
done

if [ $show_help == 1 ]; then
    usage
    exit 0
fi

BUILD_PATH="iosbp/build_ios/${BUILD_MODE}"
PRODUCT_PATH="${BUILD_PATH}/${PRODUCT_DIR}"
PRODUCT_APP_PATH="${PRODUCT_PATH}/Flutter"

start_build

exit 0
