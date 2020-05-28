//
//  CZFreeChargeHeaderView.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZFreeChargeHeaderView.h"

@implementation CZFreeChargeHeaderView

+ (instancetype)freeChargeHeaderView
{
    CZFreeChargeHeaderView *v = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return v;
}

/** 复制到剪切板 */
- (IBAction)generalPaste:(id)sender
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = self.officialWeChat;
    [CZProgressHUD showProgressHUDWithText:@"复制微信成功"];
    [CZProgressHUD hideAfterDelay:1.5];
    [recordSearchTextArray addObject:posteboard.string];
}

- (IBAction)freeDescAction:(id)sender {

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/new-rule-app.html"]];
    webVc.titleName = @"规则说明";
    [currentVc presentViewController:webVc animated:YES completion:nil];
}

@end
