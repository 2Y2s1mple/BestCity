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

/** 根据url跳淘宝*/
+ (void)jumpTaobaoWithUrlString:(NSString *)urlString;

/** 弹窗工具 */
+ (void)loadAlertView;

/** 复制搜索弹框规则 */
+ (void)pasteboardAlertViewRule;

/** 弹出分享的弹框: 仅限分享淘宝商品 */
+ (void)jumpShareViewWithUrl:(NSString *)url Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(id)thumImage object:(id)object;

/** 判断界面是否该版本下的第一次加载 */
+ (BOOL)isFirstIntoWithIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
