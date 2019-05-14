//
//  BPTFlutter.h
//  BPFlutter
//
//  Created by Lazy on 2019/3/11.
//

#if !TARGET_OS_SIMULATOR

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPTFlutter : NSObject
+ (instancetype)shared;
- (UIViewController *)subjectViewController;
- (UIViewController *)subjectDetailViewController:(NSString *)subjectID;
@end

NS_ASSUME_NONNULL_END

#endif
