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
// 极币商城
+ (void)push_pointsShop;

// 邀请好友
+ (void)push_inviteFriend;

// 新人0元购
+ (void)push_newPeopleFree;

// 新人0元购, 第二版
+ (void)push_newPeopleFree2;

// 会员中心
+ (void)push_memberOfCenter;

// 任务中心
+ (void)push_taskCenter;

// 赚钱攻略
+ (void)push_freeMoney;

// 通用的H5界面
+ (void)generalH5WithUrl:(NSString *)url title:(NSString *)title containView:(UIViewController *)containView;

// 京东专题
+ (void)push_jingDongGeneralView:(NSInteger)type;

// 淘宝, 京东, 拼多多客详情页面
+ (void)push_tabbaokeDetailWithId:(NSString *)Id title:(NSString *)title source:(NSString *)source;

// 搜索
+ (void)push_searchViewType:(NSInteger)source;

// 创建订单
+ (void)push_createMomentsWithId:(NSString *)ID source:(NSString *)source;
@end

NS_ASSUME_NONNULL_END
