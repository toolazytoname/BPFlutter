
Pod::Spec.new do |s|
  s.name             = 'BPFlutter'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BPFlutter.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://gitlab.*********.com/WP/Mobile/IOS/BPFlutter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'toolazytoname' => '*********@*********.com' }
  s.source           = { :git => 'http://gitlab.*********.com/WP/Mobile/IOS/BPFlutter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  info_plist_files = 'iosbp/build_ios/release/product/Flutter/App.framework/Info.plist', 'iosbp/build_ios/release/product/Flutter/Flutter.framework/Info.plist'
#用官方的集成方案会有很多个pod，每一个第三方组件都会是一个pod，我把所有这些都集成为一个pod
# 前面的这个文件是所有的第三方插件源码，后面是Flutter对外暴露的viewcontroller，对主工程来说，就是一个普通的ViewController而已。
  s.source_files = 'iosbp/build_ios/release/product/**/*','iosbp/BPFlutter/Classes/**/*.{h,m}'
#如果保留App.framework 和Flutter.framework 里面的Info.plist会报错，error: Multiple commands produce '/Info.plist’；
#删了呢，又会报错App installation failed，Could not inspect the application package.
#用下面这种方式可以解决
  s.exclude_files = info_plist_files
  s.vendored_frameworks = 'iosbp/build_ios/release/product/Flutter/*.framework'

  
end
