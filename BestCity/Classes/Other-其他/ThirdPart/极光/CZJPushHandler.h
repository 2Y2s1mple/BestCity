//
//  CZJPushHandler.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/14.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
////极光推送
#import "JPUSHService.h"
@interface CZJPushHandler : NSObject
+ (instancetype)shareJPushManager;
/** 初始化推送 */
- (void)setupJPUSHServiceOptions:(NSDictionary *)launchOptions;
/** 获取deviceToken */
- (void)registerDeviceToken:(NSData *)deviceToken;
//iOS7-8及以上系统接受推送消息
- (void)handleRemoteNotificationUserInfo:(NSDictionary *)userInfo;
@end
