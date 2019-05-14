//
//  BPTFlutterDemoW.h
//  BPFlutter
//
//  Created by Lazy on 2019/3/18.
//

#if !TARGET_OS_SIMULATOR
#import <Foundation/Foundation.h>
@class FlutterEngine;
@class FlutterViewController;


NS_ASSUME_NONNULL_BEGIN

@interface BPTFlutterDemoW : NSObject
- (FlutterViewController *)viewControllerWithEngine:(FlutterEngine *)engine;
@end

NS_ASSUME_NONNULL_END

#endif
