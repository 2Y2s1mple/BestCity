//
//  CZFreePushTool.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreePushTool : NSObject

+ (void)bannerPushToVC:(NSDictionary *)param;
+ (void)categoryPushToVC:(NSDictionary *)param;

// 邀请好友
+ (void)push_inviteFriend;

// 新人免单主页
+ (void)push_newPeopleFree;

// 会员中心
+ (void)push_memberOfCenter;

// 赚钱攻略
+ (void)push_freeMoney;

// 京东
+ (void)push_jingDongGeneralView:(NSInteger)type;

// 淘宝客详情页面
+ (void)tabbaokeDetailWithId:(NSString *)Id title:(NSString *)title source:(NSString *)source;

// 搜索
+ (void)push_searchView;

// 创建订单
+ (void)push_createMomentsWithId:(NSString *)ID source:(NSString *)source;
@end

NS_ASSUME_NONNULL_END
