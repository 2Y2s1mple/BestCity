//
//  CZGetJIBITool.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGetJIBITool.h"
#import "GXNetTool.h"

@implementation CZGetJIBITool
// 给极币
+ (void)getJiBiWitType:(NSNumber *)type
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"type"] = type;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/dailytask/finish"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:nil];
}
@end
