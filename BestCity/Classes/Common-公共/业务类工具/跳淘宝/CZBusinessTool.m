//
//  CZBusinessTool.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/3.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZBusinessTool.h"
#import "GXNetTool.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>
#import "TSLWebViewController.h"
#import "CZOpenAlibcTrade.h"
#import "CZSubFreePreferentialController.h"
#import "CZUserInfoTool.h"

#import "CZUpdataView.h"
#import "CZAlertView3Controller.h"
#import "CZAlertTool.h"

@implementation CZBusinessTool
#pragma mark - 购买跳淘宝, 之后弹出特惠购
+ (void)buyBtnActionWithId:(NSString *)Id alertTitle:(NSString *)alertTitle
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    NSString *string = @"dsddd"
                        @"您将前往淘宝购买此商品，下单立减"
    @"您将前往淘宝0元购买此商品，仅限首单";
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:alertTitle preferredStyle:UIAlertControllerStyleAlert];

    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        UINavigationController *naVc = tabbar.selectedViewController;
        UIViewController *toVC = naVc.topViewController;
        NSString *specialId = [NSString stringWithFormat:@"%@", JPUSERINFO[@"relationId"]];
        if ([specialId isEqualToString:@""]) {
            [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
            [[ALBBSDK sharedInstance] auth:toVC successCallback:^(ALBBSession *session) {
                NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
                NSLog(@"%@", tip);
                TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@""] actionblock:^{
                    [CZProgressHUD showProgressHUDWithText:@"授权成功"];
                    [CZProgressHUD hideAfterDelay:1.5];
                    // 为了同步关联的淘宝账号
                    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];

                }];
                webVc.modalPresentationStyle = UIModalPresentationFullScreen;
                [tabbar presentViewController:webVc animated:YES completion:nil];

                //拉起淘宝
                AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
                showParam.openType = AlibcOpenTypeAuto;
                showParam.backUrl = @"tbopen25267281://xx.xx.xx";
                showParam.isNeedPush = YES;
                showParam.nativeFailMode = AlibcNativeFailModeJumpH5;

                [CZProgressHUD hideAfterDelay:1.5];

                [[AlibcTradeSDK sharedInstance].tradeService
                 openByUrl:[NSString stringWithFormat:@"https://oauth.m.taobao.com/authorize?response_type=code&client_id=25612235&redirect_uri=https://www.jipincheng.cn/qualityshop-api/api/taobao/returnUrl&state=%@&view=wap", JPTOKEN]
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
            } failureCallback:^(ALBBSession *session, NSError *error) {
                NSString *tip=[NSString stringWithFormat:@"登录失败:%@",@""];
                NSLog(@"%@", tip);
            }];
        } else {
            // 打开淘宝
            [self openAlibcTradeWithId:Id];
        }

    }]];

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    [tabbar presentViewController:alertView animated:NO completion:nil];
}

+ (void)openAlibcTradeWithId:(NSString *)ID
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *naVc = tabbar.selectedViewController;
    UIViewController *toVC = naVc.topViewController;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"allowanceGoodsId"] = ID;

    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/allowance/apply"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:result[@"data"] parentController:toVC];
            // 1.5s我进特惠购
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CURRENTVC(currentVc);
                [currentVc.navigationController popViewControllerAnimated:NO];

                CZSubFreePreferentialController *vc = [[CZSubFreePreferentialController alloc] init];
                UITabBarController *tabbar1 = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
                UINavigationController *nav1 = tabbar1.selectedViewController;
                UIViewController *currentVc1 = nav1.topViewController;
                [currentVc1.navigationController pushViewController:vc animated:YES];
            });
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - 弹窗工具
+ (void)loadAlertView
{
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/getPopInfo"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *list = result[@"data"];
            if (list.count == 0) {
                [CZAlertTool alertRule];
                return;
            }


            // 判断数组中有几个
            if (list.count > 1) { // 两个以上
                alertList_ = [NSMutableArray array];
                for (int i = 0; i < list.count; i++) {
                    CZUpdataView *backView = [CZUpdataView buyingView];
                    backView.frame = [UIScreen mainScreen].bounds;
                    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                    backView.paramDic = list[i][@"data"];
                    [alertList_ addObject:backView];
                }

                [[UIApplication sharedApplication].keyWindow addSubview:alertList_[0]];

            } else { // 一个
                if ([list[0][@"type"] integerValue] == 1 || [list[0][@"type"] integerValue] == 0) { // 免单活动 一般活动
                    CZUpdataView *backView = [CZUpdataView buyingView];
                    backView.frame = [UIScreen mainScreen].bounds;
                    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                    [[UIApplication sharedApplication].keyWindow addSubview: backView];
                    backView.paramDic = list[0][@"data"];
                } else { // 完成首单
                    CZAlertView3Controller *vc = [[CZAlertView3Controller alloc] init];
                    vc.param = result[@"data"];
                    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    CURRENTVC(currentVc);
                    [currentVc presentViewController:vc animated:YES completion:nil];
                }
            }
        }
    } failure:^(NSError *error) {

    }];
}




@end
