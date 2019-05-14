//
//  BPTFlutterDemoW.m
//  BPFlutter
//
//  Created by Lazy on 2019/3/18.
//

#if !TARGET_OS_SIMULATOR
#import "BPTFlutterDemoW.h"
#import "Flutter.h"




@implementation BPTFlutterDemoW
- (FlutterViewController *)viewControllerWithEngine:(FlutterEngine *)engine {
//    FlutterViewController *subjectViewController = [[FlutterViewController alloc] initWithEngine:engine nibName:nil bundle:nil];
    FlutterViewController *subjectViewController = [[FlutterViewController alloc] init];
    NSDictionary *routeDic = @{@"route": @"pageName"};
    [subjectViewController setInitialRoute:[routeDic BPT_jsonString]];
    [self registerSubjectChannelWith:subjectViewController];
    return subjectViewController;
}


- (void)registerSubjectChannelWith:(UIViewController *)viewController{
    FlutterMethodChannel *subjectChannel = [FlutterMethodChannel methodChannelWithName:@"demo.flutter.app/channelName" binaryMessenger:viewController];
    [subjectChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //到跳转到专题详情页
        if ([@"methodName" isEqualToString:call.method]) {
        }
       
    }];
}

@end

#endif

