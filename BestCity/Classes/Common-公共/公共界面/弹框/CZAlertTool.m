//
//  CZAlertTool.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAlertTool.h"
#import "CZGuessTypeTowView.h"
#import "CZGuessTypeOneView.h"
#import "GXNetTool.h"

@implementation CZAlertTool

+ (void)createGuessTypeOne
{
    CZGuessTypeOneView *view1 = [CZGuessTypeOneView createView];
    [[UIApplication sharedApplication].keyWindow addSubview:view1];
}


+ (void)createGuessTypeTwo
{
    CZGuessTypeTowView *view1 = [CZGuessTypeTowView createView];
    [[UIApplication sharedApplication].keyWindow addSubview:view1];
}



+ (void)getDataSorce
{

    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"tkl"] = posteboard.string;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/getGoodsByTkl"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] isKindOfClass:[NSString class]]) {
                CZGuessTypeOneView *view1 = [CZGuessTypeOneView createView];
                view1.text = param[@"tkl"];
                
                [[UIApplication sharedApplication].keyWindow addSubview:view1];
            } else if ([result[@"data"] isKindOfClass:[NSDictionary class]]){
                CZGuessTypeTowView *view1 = [CZGuessTypeTowView createView];
                view1.dataDic = result[@"data"];
                [[UIApplication sharedApplication].keyWindow addSubview:view1];
            } else {
                [CZProgressHUD showProgressHUDWithText:@"数据格式错误"];
                [CZProgressHUD hideAfterDelay:1.5];
            }
        }
    } failure:^(NSError *error) {// 结束刷新
    }];
}


+ (void)alertRule
{
    if ([JPTOKEN length] > 0) {
        UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
        NSString *string = posteboard.string;

        if (string == nil) {
            return;
        } else {
            if ([recordSearchTextArray containsObject:string]) {
                return;
            } else {
                [recordSearchTextArray addObject:string];
                [CZAlertTool getDataSorce];
            }
        }
    }
}


@end
