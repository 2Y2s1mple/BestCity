//
//  CZGuideTool.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZGuideTool.h"
#import "CZSaveTool.h"
#import "CZTabBarController.h"
#define CZVERSION @"CZVersion"
#import "GXNetTool.h"
#import "CZUpdataManger.h"
#import "CZGuideController.h"

#import "CZAlertView1Controller.h"

#import "CZLaunchViewController.h"


BOOL oldUser;
@implementation CZGuideTool
+ (void)newpPeopleGuide
{
    //获取当前的版本号

    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    //获取存储的版本号
    NSString *lastVersion = [CZSaveTool objectForKey:CZVERSION];
    
    //比较
    if ([curVersion isEqualToString:lastVersion]) {
        oldUser = YES;
        // 显示版本更新
        [CZUpdataManger ShowUpdataViewWithNetworkService];
    } else {
        oldUser = NO;
        [CZSaveTool setObject:curVersion forKey:CZVERSION];
        // 显示获得新人红包
        CURRENTVC(currentVc);
        CZAlertView1Controller *alert1 = [[CZAlertView1Controller alloc] init];
        alert1.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [currentVc presentViewController:alert1 animated:YES completion:nil];
    }
}

+ (void)chooseRootViewController:(UIWindow *)window
{
    //获取当前的版本号
    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];

    //获取存储的版本号
    NSString *lastVersion = [CZSaveTool objectForKey:CZVERSION];

    //比较
    if ([curVersion isEqualToString:lastVersion]) {
        //没有新版本
        window.rootViewController = [[CZLaunchViewController alloc] initWithWindow:window];;
    } else {
        //有新版本
        CZGuideController *vc = [[CZGuideController alloc] init];
        window.rootViewController = vc;
    }
}




@end
