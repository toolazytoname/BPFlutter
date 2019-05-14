//
//  BPTFlutter.h
//  BPFlutter
//
//  Created by Lazy on 2019/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPTFlutter : NSObject
+ (instancetype)shared;
- (UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
