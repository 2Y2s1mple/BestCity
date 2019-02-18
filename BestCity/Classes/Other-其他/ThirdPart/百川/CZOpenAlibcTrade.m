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
    //根据链接打开页面
    id<AlibcTradePage> page = [AlibcTradePageFactory page:urlStr];
    
    //拉起淘宝
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    showParam.backUrl = @"tbopen25025861";
    showParam.isNeedPush = YES;
    showParam.nativeFailMode = AlibcNativeFailModeNone;
    
    NSInteger code = [[AlibcTradeSDK sharedInstance].tradeService show:parentController page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable tradeProcessResult) {
        NSLog(@"--------------------");
        
        if(tradeProcessResult.result ==AlibcTradeResultTypeAddCard){
            NSString *tip = [NSString stringWithFormat:@"交易成功:成功的订单%@\n，失败的订单%@\n",[tradeProcessResult payResult].paySuccessOrders, [tradeProcessResult payResult].payFailedOrders];
            NSLog(@"交易成功 --- %@", tip);
        } else if(tradeProcessResult.result==AlibcTradeResultTypeAddCard){
            NSLog(@"加入购物车");
        }
        
        
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        //        退出交易流程
        NSLog(@"--------------------");
        if (error.code==AlibcErrorCancelled) {
            return ;
        }
        NSDictionary *infor = [error userInfo];
        NSArray *orderid = [infor objectForKey:@"orderIdList"];
        NSString *tip = [NSString stringWithFormat:@"交易失败:\n订单号\n%@",orderid];
        NSLog(@"交易失败 -- %@", tip);
    }];
    
    if (code != 0) {
        [CZProgressHUD showProgressHUDWithText:@"没有安装淘宝客户端"];
        [CZProgressHUD hideAfterDelay:1.5];
    }
    
}

@end
