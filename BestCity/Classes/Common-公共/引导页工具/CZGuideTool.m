//
//  CZGuideTool.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZGuideTool.h"
#import "CZSaveTool.h"
#import "GXNetTool.h"

#import "CZGuideController.h"
#import "CZAlertView1Controller.h"
#import "CZLaunchViewController.h"
#import "CZUserUpdataView.h"
#import "CZNotificationAlertView.h"


#define CZVERSION @"CZVersion"
@implementation CZGuideTool
#pragma mark - 选择跟视图
+ (void)chooseRootViewController:(UIWindow *)window
{
    if ([CZJIPINSynthesisTool jipin_isNewVersionIs_Syn:NO]) {
        // 有新版本
        CZGuideController *vc = [[CZGuideController alloc] init];
        window.rootViewController = vc;
    } else {
        // 没有新版本
        window.rootViewController = [[CZLaunchViewController alloc] initWithWindow:window];
    }
}

#pragma mark - 加载弹框
+ (void)newpPeopleGuide
{
    if ([CZJIPINSynthesisTool jipin_isNewVersionIs_Syn:NO]) {
        // 是新版本, 显示获得新人红包
        CURRENTVC(currentVc);
        CZAlertView1Controller *alert1 = [[CZAlertView1Controller alloc] init];
        alert1.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [currentVc presentViewController:alert1 animated:YES completion:nil];
    } else {
        // 没有新版本, 请求服务器判断是否版本更新
        [self ShowUpdataViewWithNetworkService];
    }
}


// 服务器获取最新版本
+ (void)ShowUpdataViewWithNetworkService
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"0";
    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    param[@"clientVersionCode"] = curVersion;
    
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getAppVersion"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSDictionary *versionInfo = [result[@"data"] deleteAllNullValue];
            //有新版本
            [CZSaveTool setObject:versionInfo forKey:requiredVersionCode];
            //比较
            BOOL isAscending = [curVersion compare:result[@"data"][@"versionCode"]] == NSOrderedAscending;
            BOOL isOpen = [result[@"data"][@"open"] isEqualToNumber:@(1)];
            if (isAscending && isOpen) {
                // 更新弹框
                CZUserUpdataView *alertView = [CZUserUpdataView userUpdataView];
                alertView.frame = [UIScreen mainScreen].bounds;
                alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                alertView.versionMessage = result[@"data"];
                [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            } else {
                // 推送弹框
                CZNotificationAlertView *NotiView = [CZNotificationAlertView notificationAlertView];
                [NotiView checkCurrentNotificationStatus];
            }
        }
    } failure:^(NSError *error) {}];
}


@end
