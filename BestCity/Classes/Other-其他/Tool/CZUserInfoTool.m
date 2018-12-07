//
//  CZUserInfoTool.m
//  BestCity
//
//  Created by JasonBourne on 2018/10/20.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZUserInfoTool.h"
#import "GXNetTool.h"

@implementation CZUserInfoTool

/** 获取用户信息*/
+ (void)userInfoInformation:(CZUserInfoBlock)block
{
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/modelUser"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
//            NSLog(@"%@", result);
            NSDictionary *userInfo = [[result[@"list"] firstObject] deleteAllNullValue];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"user"];
            // 积分
            [[NSUserDefaults standardUserDefaults] setObject:result[@"points"] forKey:@"point"];
            
            block(result);
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 修改用户信息*/
+ (void)changeUserInfo:(NSDictionary *)info callbackAction:(CZUserInfoBlock)action
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    [param addEntriesFromDictionary:info];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/ModelUserUpdate"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        
//        NSLog(@"result ----- %@", result);
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [CZProgressHUD showProgressHUDWithText:@"修改成功"];
            
            action(result);
        } else {
            [CZProgressHUD showProgressHUDWithText:@"修改失败"];
        }
        [CZProgressHUD hideAfterDelay:2];
        
    } failure:^(NSError *error) {
        
    }];
}
@end
