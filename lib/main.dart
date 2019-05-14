//import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/exception_catch.dart';
import 'package:flutter_app/utils/ycroute.dart';
//import 'package:flutter/rendering.dart';

void main() {
//  debugPaintSizeEnabled=true;
  // 调用window拿到route判断跳转哪个界面
//  runApp(_widgetForRoute(ui.window.defaultRouteName));
  return ExceptionCatch.register(()=>runApp(YCRoute.widgetForRoute(ui.window.defaultRouteName)));
//  runApp(YCRoute.widgetForRoute(ui.window.defaultRouteName));
}






