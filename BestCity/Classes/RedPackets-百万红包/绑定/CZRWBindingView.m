//
//  CZRWBindingView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/24.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRWBindingView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GXNetTool.h"

@interface CZRWBindingView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UITextField *textField;
@end


@implementation CZRWBindingView
+ (instancetype)RWBindingView
{
    CZRWBindingView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.width = SCR_WIDTH;
    return view;
}

// 去授权
- (IBAction)doAPAuth
{
    NSLog(@"去授权");

    [self getAuthAlipayData];

}

// 绑定账号
- (IBAction)bingzhifubao
{
    NSLog(@"绑定支付宝");
    if (self.textField.text.length > 0) {
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/bindingAlipay"];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"realname"] = self.textField.text;
        [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"code"] isEqual:@(0)]) {

            } else {
                [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            }
            // 取消菊花
            [CZProgressHUD hideAfterDelay:1.5];
        } failure:nil];
    } else {
        [CZProgressHUD showProgressHUDWithText:@"请输入真实姓名"];
        [CZProgressHUD hideAfterDelay:1.5];
    }
}


- (void)authAlipayWithID:(NSString *)str
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"jipincheng";

    // 将授权信息拼接成字符串
    NSString *authInfoStr = str;
    NSLog(@"authInfoStr = %@",authInfoStr);
    [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                     fromScheme:appScheme
                                       callback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
        [self getAuthAlipayDataWithAuthCode:authCode];
    }];
}


// 获取信息
- (void)getAuthAlipayData
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/alipay/getAuthInfo"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [self authAlipayWithID:result[@"data"]];
        }
    } failure:^(NSError *error) {

    }];
}


- (void)getAuthAlipayDataWithAuthCode:(NSString *)str
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/alipay/returnUrl"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"authCode"] = str;
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {

        }
    } failure:^(NSError *error) {

    }];
}



@end
