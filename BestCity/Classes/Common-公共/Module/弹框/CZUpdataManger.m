//
//  CZUpdataManger.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUpdataManger.h"
#import "GXNetTool.h"
#import "CZUpdataView.h"

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
            //有新版本
            [CZSaveTool setObject:result[@"data"] forKey:requiredVersionCode];
            //比较
            BOOL isAscending = [curVersion compare:result[@"data"][@"versionCode"]] == NSOrderedAscending;
            BOOL isOpen = [result[@"data"][@"open"] isEqualToNumber:@(1)];
            if (isAscending && isOpen) {
                // 判断是否更新
                id<CZUpdataProtocol> backView = [self createUpdataManger];
                backView.versionMessage = result[@"data"];
                [[UIApplication sharedApplication].keyWindow addSubview:[backView getView]];
            }
        }
    } failure:^(NSError *error) {}];
}

+ (id<CZUpdataProtocol>)createUpdataManger
{
    // 判断是否更新
    id<CZUpdataProtocol> backView = [CZUpdataView updataViewWithFrame:[UIScreen mainScreen].bounds];
    [backView getView].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    return backView;
}

@end
