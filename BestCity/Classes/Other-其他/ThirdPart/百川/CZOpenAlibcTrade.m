//
//  CZOpenAlibcTrade.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/27.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZOpenAlibcTrade.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>

@implementation CZOpenAlibcTrade
#pragma mark - 跳转到淘宝
+ (void)openAlibcTradeWithUrlString:(NSString *)urlStr parentController:(UIViewController *)parentController
{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"taobao://"]]) {
        [CZProgressHUD showProgressHUDWithText:@"没有安装淘宝客户端"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    
    
    //根据链接打开页面
    id<AlibcTradePage> page = [AlibcTradePageFactory page:urlStr];
    
    //拉起淘宝
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    showParam.backUrl = @"tbopen25025861";
    showParam.isNeedPush = YES;
    showParam.nativeFailMode = AlibcNativeFailModeNone;
    
    [[AlibcTradeSDK sharedInstance].tradeService show:parentController page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable tradeProcessResult) {
            if(tradeProcessResult.result == AlibcTradeResultTypeAddCard){
                NSLog(@"交易成功");
            } else if(tradeProcessResult.result == AlibcTradeResultTypeAddCard){
                NSLog(@"加入购物车");
            }
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        NSLog(@"----------退出交易流程----------");
    }];
    
}

@end
