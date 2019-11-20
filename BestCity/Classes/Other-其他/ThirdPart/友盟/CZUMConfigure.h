//
//  CZUMConfigure.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>

typedef NS_ENUM(NSUInteger, CZUMConfigureType) {
    CZUMConfigureTypeMiniProgramFree, // 免单
    CZUMConfigureTypeMiniProgramFreeOldUserList, // 免单老人页面
    CZUMConfigureTypeMiniProgramFreeOldUserDetail, // 免单老人详情
    CZUMConfigureTypeMiniProgramFreeNewUserDetail, // 新人详情页面
    CZUMConfigureTypeMiniProgramGoods, // 商品
    CZUMConfigureTypeMiniProgramEvaluate, // 评测
    CZUMConfigureTypeWeb, // 网页
    CZUMConfigureTypeImage, // 图片

};


@interface CZUMConfigure : NSObject
+ (instancetype)shareConfigure;
- (void)configure;
- (void)shareToPlatformType:(UMSocialPlatformType)platformType currentViewController:(UIViewController *)vc webUrl:(NSString *)webUrl Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage shareType:(NSInteger)type object:(id)anObject;

// 新
- (void)sharePlatform:(UMSocialPlatformType)platform controller:(UIViewController *)vc url:(NSString *)webUrl Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(id)thumImage shareType:(CZUMConfigureType)type object:(id)anObject;
@end
