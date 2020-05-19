//
//  CZJIPINSynthesisTool.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZUMConfigure.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CZJIPINModuleType){
    CZJIPINModuleHotSale,
    CZJIPINModuleDiscover,
    CZJIPINModuleEvaluation,
    CZJIPINModuleTrail,
    CZJIPINModuleTrailReport,
    CZJIPINModuleBK,
    CZJIPINModuleRelationBK,
    CZJIPINModuleMe,
    CZJIPINModuleQingDan,
};

@interface CZJIPINSynthesisTool : NSObject

+ (NSString *)getModuleTypeNumber:(CZJIPINModuleType)type;

+ (CZJIPINModuleType)getModuleType:(NSInteger)typeNumber;

/** 删除关注 */
+ (void)deleteAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action;

/** 新增关注 */
+ (void)addAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action;

/** 0元购跳淘宝购买 */
+ (void)buyBtnActionWithId:(NSString *)Id alertTitle:(NSString *)alertTitle;

/** 淘宝授权 */
+ (void)jipin_authTaobaoSuccess:(void (^)(BOOL isAuthTaobao))block;

/** 根据url跳淘宝*/
+ (void)jipin_jumpTaobaoWithUrlString:(NSString *)urlString;

/** 获取不是备用金的购买链接 */
+ (void)jipin_buyLinkById:(NSString *)Id andSource:(NSString *)source;

/** 复制搜索弹框规则 */
+ (void)pasteboardAlertViewRule;

/** 弹出分享的弹框: 仅限分享淘宝商品 */
+ (void)jumpShareViewWithUrl:(NSString *)url Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(id)thumImage object:(id)object;

/** 保存图片到本地 */
+ (void)jipin_saveImage:(id)image;

/** 点击图片放大 */
+ (void)jipin_showZoomImage:(__kindof UIView * _Nonnull)obj;

#pragma mark - 分享模块
/** 友盟分享纯图片*/
+ (void)JINPIN_UMShareImage:(id)thumImage Type:(UMSocialPlatformType)type;

/** 友盟分享web*/
+ (void)JINPIN_UMShareWeb:(NSString *)url Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage Type:(UMSocialPlatformType)type;

/** 友盟分享纯文字 */
+ (void)JINPIN_UMShareText:(NSString *)text Type:(UMSocialPlatformType)type;

/** 友盟分享小程序 */
+ (void)JINPIN_UMShareMiniPath:(NSString *)path Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage userName:(NSString *)userName failureUrl:(NSString *)url;

/** 调用系统分享多图片 */
+ (void)JINPIN_systemShareImages:(NSArray *)images success:(void (^)(BOOL completed))block;

/** 统一UI样式2, 分享网页*/
+ (void)JIPIN_UMShareUI2_Web:(NSDictionary *)webParam;

#pragma mark - 启动有关
/** 项目启动 */
+ (void)jipin_projectEngine:(UIWindow *)window;

/** 开启弹窗 */
+ (void)jipin_globalAlertWithNewVersion:(BOOL)isNewVersion;

/** 隐私政策弹框 */
+ (void)jipin_privacyPolicyAlertView:(void (^)(BOOL isAgree))block;

/** 弹窗工具 */
+ (void)jipin_loadAlertView;

/** 是否是新版本 */
+ (BOOL)jipin_isNewVersion;

/** 是否是新人 */
+ (BOOL)jipin_isNewUser;

/** 判断界面是否该版本下的第一次加载 */
+ (void)jipin_isFirstIntoWithIdentifier:(Class)currentClass info:(void (^)(BOOL isFirstInto, NSInteger count))infoBlcok;

@end

NS_ASSUME_NONNULL_END
