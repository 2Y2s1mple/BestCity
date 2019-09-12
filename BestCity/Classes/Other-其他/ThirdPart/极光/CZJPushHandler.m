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
        [self pushToVC:userInfo];
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
        [self pushToVC:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)pushToVC:(NSDictionary *)param
{
//0默认消息，1榜单首页，11榜单详情，12商品详情，2评测主页，21评测文章，23清单文章web，24清单文章json，3新品主页，31新品详情，4免单主页，41免单详情
    NSInteger targetType  = [param[@"targetType"] integerValue];
    NSString *targetId = param[@"targetId"];
    NSString *targetTitle = param[@"targetTitle"];

    switch (targetType) {
        case 11:
        {
            CZMainHotSaleDetailController *vc = [[CZMainHotSaleDetailController alloc] init];
            vc.ID = targetId;
            vc.titleText = [NSString stringWithFormat:@"%@榜单", targetTitle];
           UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 12:
        {
            CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
            vc.goodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 1;
            break;
        }
        case 21:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleEvaluation;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 23:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleQingDan;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 24:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleQingDan;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            WMPageController *hotVc = (WMPageController *)nav.topViewController;
            hotVc.selectIndex = 0;
            break;
        }
        case 31:
        {
            CZTrialDetailController *vc = [[CZTrialDetailController alloc] init];
            vc.trialId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            WMPageController *hotVc = (WMPageController *)nav.topViewController;
            hotVc.selectIndex = 1;
            break;
        }
        case 41:
        {
            CZFreeChargeDetailController *vc = [[CZFreeChargeDetailController alloc] init];
            vc.Id = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
        }
        default:
            break;
    }





}


@end
