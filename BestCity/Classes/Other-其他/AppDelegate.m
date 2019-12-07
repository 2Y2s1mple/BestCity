//
//  AppDelegate.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "AppDelegate.h"
#import "CZJPushHandler.h"
#import "CZUMConfigure.h"
#import "CZGuideTool.h"
#import "CZOpenAlibcTrade.h"
//#import "UMSocialSnsService.h"
#import "GXNetTool.h"
#import "CZAlertTool.h"
#import "CZLaunchViewController.h"

#import <MobLinkPro/IMLSDKRestoreDelegate.h>
#import <MobLinkPro/MobLink.h>
#import <MobLinkPro/MLSDKScene.h>

@interface AppDelegate () <IMLSDKRestoreDelegate>

/** <#注释#> */
@property (nonatomic, strong) MLSDKScene *recordScene;
@property (nonatomic) dispatch_queue_t guideQueue;
@property (nonatomic) dispatch_semaphore_t guideSemaphore;
@property (nonatomic) BOOL isAlreadyRun;
/** <#注释#> */
@property (nonatomic, assign) NSInteger flagNumber;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    // 设置跟视图
    [[CZLaunchViewController alloc] initWithWidow:self.window];

    // 加载极光推送
    [[CZJPushHandler shareJPushManager] setupJPUSHServiceOptions:launchOptions];

    // 加载友盟分享
   [[CZUMConfigure shareConfigure] configure];

    // 加载阿里百川
    [CZOpenAlibcTrade shareConfigure];

    // 设置MobLink代理
    [MobLink setDelegate:self];

    [self.window makeKeyAndVisible];

    recordSearchTextArray = [NSMutableArray array];

    return YES;
}

- (void)IMLSDKWillRestoreScene:(MLSDKScene *)scene Restore:(void (^)(BOOL, RestoreStyle))restoreHandler
{
    NSLog(@"Will Restore Scene - Path:%@",scene.path);
    NSLog(@"------%@", self.recordScene.params);
    NSLog(@"----%@", scene.params);
    if ([self.recordScene.params isEqualToDictionary:scene.params]) {
        return;
    };

    NSString *path = scene.path == nil ? @"" : scene.path;
    NSString *className = scene.className == nil ? @"" : scene.className;

    __block NSMutableString *msg = [NSMutableString stringWithFormat:@"路径path\n%@ \n\n类名\n%@ \n\n参数", path, className];

     restoreHandler(YES, MLPush);

    self.recordScene = scene;
}

- (void)IMLSDKCompleteRestore:(MLSDKScene *)scene
{
    NSLog(@"Complete Restore -Path:%@",scene.path);
}

- (void)IMLSDKNotFoundScene:(MLSDKScene *)scene
{
    NSLog(@"Not Found Scene - Path :%@",scene.path);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有找到路径"
                                                        message:[NSString stringWithFormat:@"Path:%@",scene.path]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];

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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 友盟
    [[UMSocialManager defaultManager] handleOpenURL:url];
    // 百川
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
    }
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    // Customer Code
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    // 友盟
    [[UMSocialManager defaultManager] handleOpenURL:url];
    // 百川
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                             options:options]) {
        //处理其他app跳转到自己的app，如果百川处理过会返回YES
    }
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    return YES;
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
    self.flagNumber++;
    if (self.flagNumber > 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchAlert" object:nil];
    }

    NSLog(@"x555555555");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
