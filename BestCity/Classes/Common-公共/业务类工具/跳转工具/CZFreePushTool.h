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
@end

NS_ASSUME_NONNULL_END
