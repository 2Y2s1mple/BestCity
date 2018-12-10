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
#import "CZGuideController.h"
#define CZVERSION @"CZVersion"
#import "GXNetTool.h"

@implementation CZGuideTool
+ (void)chooseRootViewController:(UIWindow *)window
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @(0);
    param[@"clientVersionCode"] = @"1.00";
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/getAppVersion"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSNumber *appVersion1 = result[@"appVersion"][@"open"];
            if (![appVersion1 isEqual:@(0)]) {
                appVersion = YES;
            } else {
                appVersion = NO;
            }
            //有新版本
            [CZSaveTool setObject:result[@"appVersion"] forKey:requiredVersionCode];
        }
    } failure:^(NSError *error) {}];
    
     [self loadController:window];
}

+ (void)loadController:(UIWindow *)window
{
    //获取当前的版本号
    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    //获取存储的版本号
    NSString *lastVersion = [CZSaveTool objectForKey:CZVERSION];
    
    //比较
    if ([curVersion isEqualToString:lastVersion]) {
        //没有新版本
        window.rootViewController = [[CZTabBarController alloc] init];
    } else {
        //有新版本
        [CZSaveTool setObject:curVersion forKey:CZVERSION];
        CZGuideController *vc = [[CZGuideController alloc] init];
        window.rootViewController = vc;
    }
}

@end
