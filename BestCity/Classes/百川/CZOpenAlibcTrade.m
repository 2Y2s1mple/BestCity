//
//  CZOpenAlibcTrade.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/27.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZOpenAlibcTrade.h"
#import "TSLWebViewController.h"


@implementation CZOpenAlibcTrade
#pragma mark - 初始化
+ (void)shareConfigure
{
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSLog(@" 百川平台基础SDK初始化，加载并初始化各个业务能力插件");
    } failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
}

#pragma mark - 跳转到淘宝
+ (void)openAlibcTradeWithUrlString:(NSString *)urlStr parentController:(UIViewController *)parentController
{
    
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    
    if ([parentController isKindOfClass:[UIViewController class]]) {
        parentController = tabbar;
    }

//    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"taobao://"]]) {
//        [CZProgressHUD showProgressHUDWithText:@"没有安装淘宝客户端"];
//        [CZProgressHUD hideAfterDelay:1.5];
//        return;
//    }

    TSLWebViewController *webVc = [[TSLWebViewController alloc] init];

    //拉起淘宝
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    showParam.backUrl = @"tbopen25267281";
    showParam.isNeedPush = NO;
    showParam.nativeFailMode = AlibcNativeFailModeJumpH5;

    [CZProgressHUD hideAfterDelay:1.5];

    [[AlibcTradeSDK sharedInstance].tradeService
                                    openByUrl:urlStr
                                    identity:@"trade"
                                    webView:webVc.webView
                                    parentController:tabbar
                                    showParams:showParam
                                    taoKeParams:nil
                                    trackParam:nil
     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
         NSLog(@"-----AlibcTradeSDK------");
         if(result.result == AlibcTradeResultTypeAddCard){
             NSLog(@"交易成功");
         } else if(result.result == AlibcTradeResultTypeAddCard){
             NSLog(@"加入购物车");
         }
     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
         NSLog(@"----------退出交易流程----------");
     }];

//    [[AlibcTradeSDK sharedInstance].tradeService show:parentController page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable tradeProcessResult) {
//        NSLog(@"-----AlibcTradeSDK------");
//            if(tradeProcessResult.result == AlibcTradeResultTypeAddCard){
//                NSLog(@"交易成功");
//            } else if(tradeProcessResult.result == AlibcTradeResultTypeAddCard){
//                NSLog(@"加入购物车");
//            }
//    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//        NSLog(@"----------退出交易流程----------");
//    }];
}

@end
