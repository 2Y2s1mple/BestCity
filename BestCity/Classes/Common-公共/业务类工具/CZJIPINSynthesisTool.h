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

/** 跳淘宝购买 */
+ (void)buyBtnActionWithId:(NSString *)Id alertTitle:(NSString *)alertTitle;

/** 淘宝授权 */
+ (void)jipin_authTaobao;

/** 根据url跳淘宝*/
+ (void)jipin_jumpTaobaoWithUrlString:(NSString *)urlString;

/** 弹窗工具 */
+ (void)loadAlertView;

/** 复制搜索弹框规则 */
+ (void)pasteboardAlertViewRule;

/** 弹出分享的弹框: 仅限分享淘宝商品 */
+ (void)jumpShareViewWithUrl:(NSString *)url Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(id)thumImage object:(id)object;

/** 判断界面是否该版本下的第一次加载 */
+ (BOOL)isFirstIntoWithIdentifier:(NSString *)identifier;

/** 全局分享统一UI*/
+ (void)UMShareUIWithTarget:(id)target Action:(SEL)action;

/** 友盟分享纯图片*/
+ (void)JINPIN_UMShareImage:(id)thumImage Type:(UMSocialPlatformType)type;

/** 友盟分享web*/
+ (void)JINPIN_UMShareWeb:(NSString *)url Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage Type:(UMSocialPlatformType)type;

/** 保存图片到本地 */
+ (void)jipin_saveImage:(id)image;
@end

NS_ASSUME_NONNULL_END
