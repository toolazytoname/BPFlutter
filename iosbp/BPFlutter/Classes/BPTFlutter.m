//
//  BPTFlutter.m
//  BPFlutter
//
//  Created by Lazy on 2019/3/11.
//
#if !TARGET_OS_SIMULATOR
#import "Flutter.h"
#import "GeneratedPluginRegistrant.h"
#import "BPTFlutterDemoW.h"
#import "BPTFlutterSubjectDetailW.h"
#import "BPTFlutter.h"

@interface BPTFlutter()
//@property (nonatomic, strong) FlutterEngine *engine;
@property (nonatomic, strong) BPTFlutterDemoW *subjectW;
@property (nonatomic, strong) BPTFlutterSubjectDetailW *subjectDetailW;

@end

@implementation BPTFlutter
+ (instancetype)shared {
    static BPTFlutter *flutter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flutter = [[self alloc] init];
    });
    return flutter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self initialEngine];
        _subjectW = [[BPTFlutterDemoW alloc] init];
        _subjectDetailW = [[BPTFlutterSubjectDetailW alloc] init];

    }
    return self;
}

//- (void)initialEngine {
//    _engine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
//    [_engine runWithEntrypoint:nil];
//    [GeneratedPluginRegistrant registerWithRegistry:_engine];
//}

- (UIViewController *)subjectViewController {
    FlutterViewController *subjectViewController =
    [self.subjectW viewControllerWithEngine:nil];
    [self generatedPluginRegistrant:subjectViewController.engine];
    return subjectViewController;
}

- (UIViewController *)subjectDetailViewController:(NSString *)subjectID {
    FlutterViewController *detailViewController =
    [self.subjectDetailW viewControllerWithsubjectID:subjectID engine:nil];
    [self generatedPluginRegistrant:detailViewController.engine];
    return detailViewController;

}



/**
 为了解决这个问题 https://github.com/flutter/flutter/issues/27216

 @param engine  engine
 */
- (void)generatedPluginRegistrant:(FlutterEngine *)engine{
    [GeneratedPluginRegistrant registerWithRegistry:engine];
}



@end
#endif






