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
#import "CZAlertView4Controller.h"

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
    param[@"keyword"] = posteboard.string;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getInfoByKeyword"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"][@"type"] isEqual: @(1)]) {
                if ([result[@"data"] isKindOfClass:[NSDictionary class]]){
                    CZGuessTypeTowView *view1 = [CZGuessTypeTowView createView];
                    view1.dataDic = result[@"data"][@"data"];
                    [[UIApplication sharedApplication].keyWindow addSubview:view1];
                } else {
                    CZGuessTypeOneView *view1 = [CZGuessTypeOneView createView];
                    view1.text = param[@"keyword"];
                    [[UIApplication sharedApplication].keyWindow addSubview:view1];
                }
            } else {
                CZAlertView4Controller *vc = [[CZAlertView4Controller alloc] init];
                vc.param = result;
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                CURRENTVC(currentVc);
                [currentVc presentViewController:vc animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {// 结束刷新
    }];
}

+ (void)alertRule
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    NSString *string = posteboard.string;

    if (string == nil) {
        return;
    } else {
        if ([recordSearchTextArray containsObject:string]) {
            return;
        } else {
            [CZAlertTool getDataSorce];
            [recordSearchTextArray addObject:string];
            posteboard.string = nil;
        }
    }
}


@end
