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

#import "CZLaunchViewController.h"

#import <MobLinkPro/IMLSDKRestoreDelegate.h>
#import <MobLinkPro/MobLink.h>
#import <MobLinkPro/MLSDKScene.h>

#import "WXApi.h"

#import "CZFreeChargeDetailController.h"
#import "CZTaobaoDetailController.h"
#import "CZDChoiceDetailController.h"

#import "GXWindow.h"

@interface AppDelegate () <IMLSDKRestoreDelegate, WXApiDelegate>

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


    self.window = [[GXWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];


//    JPSERVER_URL = @"https://www.jipincheng.cn/qualityshop-api/"; // 正式
    JPSERVER_URL = @"http://192.168.1.84:8081/qualityshop-api/";//公司的路由
//    JPSERVER_URL = @"http://47.99.243.255:8081/qualityshop-api/"; // 测试
//    http://47.99.243.255:8081/qualityshop-api/swagger-ui.html
//    if ([[CZSaveTool objectForKey:@"currentPath"] length] > 0) {
//        JPSERVER_URL = [CZSaveTool objectForKey:@"currentPath"];
//    } else {
//        JPSERVER_URL = @"https://www.jipincheng.cn/qualityshop-api/";
//    }


    // 设置跟视图
    [CZGuideTool chooseRootViewController:self.window];

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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CURRENTVC(currentVc);
        if (NSClassFromString(className) == [currentVc class]) {
            // 5秒之后, 当前这个页面还在显示不清空
        } else {
            self.recordScene = nil;
        }
    });
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
    [WXApi handleOpenURL:url delegate:self];
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
    [WXApi handleOpenURL:url delegate:self];

    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    return YES;
}


-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
       ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        [self pushToVC:msg.messageExt];
        NSLog(@"%@", msg.messageExt);
    }
}

- (void)pushToVC:(NSString *)text
{

    NSArray *textArr = [text componentsSeparatedByString:@"&"];
    NSString *type = [[[textArr firstObject] componentsSeparatedByString:@"="] lastObject];
    NSString *ID = [[textArr[1] componentsSeparatedByString:@"="] lastObject];
    NSString *articleType = [[[textArr lastObject] componentsSeparatedByString:@"="] lastObject];


    //        1.免单新人详情页  type=0&id=xxx
    //        2.免单老人免单详情页 type=1&id=xxx
    //        3.app首页type=3&id=0
    //
    //        4.新的商品详情页： type=2&id=xxx
    //        5.评测详情页：  contentType：1
    //        type=3&id=xxx&articleType=文章type
    //                     contentType：3
    //        type=4&id=xxx&articleType=文章type

    //0默认消息，1榜单首页，11榜单详情，12商品详情，2评测主页，21评测文章，23清单文章web，24清单文章json，3新品主页，31新品详情，4免单主页，41免单详情, 5免单

    switch ([type integerValue]) {
        case 0:
        {
            CZFreeChargeDetailController *vc = [[CZFreeChargeDetailController alloc] init];
            vc.Id = ID;
            vc.isOldUser = NO;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            CZFreeChargeDetailController *vc = [[CZFreeChargeDetailController alloc] init];
            vc.Id = ID;
            vc.isOldUser = YES;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
            vc.otherGoodsId = ID;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            if ([ID isEqual:@"0"]) {
                UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                tabbar.selectedIndex = 1;
            } else {
                CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
                vc.detailType = CZJIPINModuleQingDan;
                vc.findgoodsId = ID;
                UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                UINavigationController *nav = tabbar.selectedViewController;
                [nav pushViewController:vc animated:YES];
            }
            break;
        }
        case 4:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleQingDan;
            vc.findgoodsId = ID;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }

        default:
            break;
    }
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
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchAlert" object:nil];

    NSLog(@"x555555555");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
