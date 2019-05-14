//
//  BPTFlutter.m
//  BPFlutter
//
//  Created by Lazy on 2019/3/11.
//

#import "BPTFlutter.h"
#import <BPFlutter/Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h> // Only if you have Flutter Plugins


@interface BPTFlutter()
@property (nonatomic,strong) FlutterEngine *engine;

@end

@implementation BPTFlutter
+ (instancetype)shared {
    static BPTFlutter *flutter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flutter = [[BPTFlutter alloc] init];
        [flutter initialEngine];
        
    });
    return flutter;
}

- (void)initialEngine {
    _engine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
    [_engine runWithEntrypoint:nil];
    [GeneratedPluginRegistrant registerWithRegistry:_engine];
}

- (UIViewController *)viewController {
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithEngine:self.engine nibName:nil bundle:nil];
    return flutterViewController;
}
@end
