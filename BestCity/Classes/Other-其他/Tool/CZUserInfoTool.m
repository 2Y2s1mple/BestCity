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
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/getUserInfo"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 用户数据
            NSDictionary *userDic = [result[@"data"] deleteAllNullValue];
            
            // 存储用户信息, 都TM存储上了, 这个接口没有token返回
            [CZSaveTool setObject:userDic forKey:@"user"];
            
            !block ? : block(userDic);
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 修改用户信息*/
+ (void)changeUserInfo:(NSDictionary *)info callbackAction:(CZUserInfoBlock)action
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:info];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/update"];
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

+ (void)userInfoCommssionCallback:(CZUserInfoBlock)action
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/v2/myCommssionSummary"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSDictionary *dic = [result[@"data"] changeAllNnmberValue];
            !action ? : action(dic);
        }
    } failure:^(NSError *error) {

    }];
}
@end
