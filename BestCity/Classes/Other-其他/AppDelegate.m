//
//  AppDelegate.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "AppDelegate.h"
#import "CZTabBarController.h"
#import "CZJPushHandler.h"
#import "CZUMConfigure.h"
#import "CZGuideTool.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 设置引导页
    [CZGuideTool chooseRootViewController:self.window];
    
    [self.window makeKeyAndVisible];
    
    //加载极光推送
    [[CZJPushHandler shareJPushManager] setupJPUSHServiceOptions:launchOptions];
    
    //加载友盟分享
   [[CZUMConfigure shareConfigure] configure];
    
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSLog(@" 百川平台基础SDK初始化，加载并初始化各个业务能力插件");
    } failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];

    return YES;
}

#pragma mark -
#pragma mark 关于推送的代码
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //获取设备号
    [[CZJPushHandler shareJPushManager] registerDeviceToken:deviceToken];
}
#pragma mark 推送失败回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //设备号错误是的回调
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary * _Nonnull)userInfo fetchCompletionHandler:(void (^ _Nonnull)(UIBackgroundFetchResult))completionHandler
{
    //7-8系统的推送回调
    [[CZJPushHandler shareJPushManager] handleRemoteNotificationUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}










#pragma mark - 系统的方法
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
