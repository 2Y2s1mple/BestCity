//
//  CZJPushHandler.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/14.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZJPushHandler.h"
#import "CZMainHotSaleDetailController.h" // 榜单
#import "CZRecommendDetailController.h" // 商品详情
#import "CZDChoiceDetailController.h" // 测评文章
#import "WMPageController.h"
#import "CZTrialDetailController.h" // 新品试用
#import "CZFreeChargeDetailController.h"
#import "CZFreePushTool.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface CZJPushHandler ()<JPUSHRegisterDelegate>

@end

@implementation CZJPushHandler
static id _instance;
+ (instancetype)shareJPushManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] init];
    });
    return _instance;
}

#pragma mark - 注册 DeviceToken
- (void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)handleRemoteNotificationUserInfo:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
}

- (void)setupJPUSHServiceOptions:(NSDictionary *)launchOptions{
    // 初始化APNs代码
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {}

//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    // 初始化JPush代码
    [JPUSHService setupWithOption:launchOptions appKey:@"09099048e2130ae6ff8151bc"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];

//    // 添加tag
//    NSSet *set = [NSSet setWithObject:@"cjxx"];
//    [JPUSHService addTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//        NSLog(@"iResCode = %ld, iTags = %@, seq = %ld", (long)iResCode, iTags, (long)seq);
//    } seq:1122];
//
//    // 添加别名
//    [JPUSHService setAlias:@"test1" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"iResCode = %ld, iAlias = %@, seq = %ld", (long)iResCode, iAlias, (long)seq);
//    } seq:1122];
}

//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的 Extras 附加字段，key 是自己定义的
//}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate

#pragma mark 手机在前台接受到的
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){

    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
//        [self pushToVC:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge |UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

#pragma mark 手机在后台接受到的
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSInteger currentBadge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:currentBadge + [badge integerValue]];
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        PushData_ = userInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JiGuangPushNotifi" object:nil];

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}", body, title, subtitle, badge, sound, userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)pushToVC:(NSDictionary *)param
{
    // 跳转类型：0不跳转(默认首页)，11.专题页面 12.淘宝客详情页面,13.H5页面，14.极币商城，15.任务中心，16.红包主页(暂时榜单主页)，17.榜单主页(隐藏)，18特惠购列表,19京东商品详情,20拼多多商品详情
    NSDictionary *dic = param;
    NSDictionary *param1 = @{
        @"targetType" : dic[@"targetType"] == nil ? @"" : dic[@"targetType"],
        @"targetId" : dic[@"targetId"] == nil ? @"" : dic[@"targetId"],
        @"targetTitle" : dic[@"targetTitle"] == nil ? @"" : dic[@"targetTitle"],
    };
    [CZFreePushTool bannerPushToVC:param1];
}


@end
