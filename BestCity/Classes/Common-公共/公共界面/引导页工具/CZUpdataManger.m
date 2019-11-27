//
//  CZUpdataManger.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUpdataManger.h"
#import "GXNetTool.h"
#import "CZUserUpdataView.h"
#import "CZNotificationAlertView.h"

@implementation CZUpdataManger
+ (void)ShowUpdataViewWithNetworkService
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"0";
    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    param[@"clientVersionCode"] = curVersion;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getAppVersion"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSNumber *appVersion1 = result[@"data"][@"open"];
            if (![appVersion1 isEqual:@(0)]) {} else {}

            NSDictionary *versionInfo = [result[@"data"] deleteAllNullValue];
            //有新版本
            [CZSaveTool setObject:versionInfo forKey:requiredVersionCode];
            //比较
            BOOL isAscending = [curVersion compare:result[@"data"][@"versionCode"]] == NSOrderedAscending;
            BOOL isOpen = [result[@"data"][@"open"] isEqualToNumber:@(1)];
            if (isAscending && isOpen) {
                // 判断是否更新
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
