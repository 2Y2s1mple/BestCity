//
//  CZUMConfigure.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
@interface CZUMConfigure : NSObject
+ (instancetype)shareConfigure;
- (void)configure;
- (void)shareToPlatformType:(UMSocialPlatformType)platformType currentViewController:(UIViewController *)vc webUrl:(NSString *)webUrl Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage shareType:(NSInteger)type object:(id)anObject;
@end
