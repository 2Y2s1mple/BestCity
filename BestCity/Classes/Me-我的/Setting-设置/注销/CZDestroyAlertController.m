//
//  CZDestroyAlertController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/18.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZDestroyAlertController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"

@interface CZDestroyAlertController ()

@end

@implementation CZDestroyAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"注销账号" rightBtnTitle:@"" rightBtnAction:nil];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
}

#pragma mark - 提交
- (IBAction)submitAction:(id)sender
{
    NSLog(@"---------");
    // 参数
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/logout"];
    // 请求
    [GXNetTool PostNetWithUrl:url body:@{} bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {} failure:^(NSError *error) {}];
    // 删除用户信息
    [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"user"];
    // 删除token
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 返回上一页
    CZLoginController *vc = [CZLoginController shareLoginController];
    vc.isLogin = NO;
    [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
    
}


@end
