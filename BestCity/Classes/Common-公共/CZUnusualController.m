//
//  CZUnusualController.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUnusualController.h"
#import "UIButton+CZExtension.h" // 按钮扩展

@interface CZUnusualController ()
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
@end

@implementation CZUnusualController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载pop按钮
    [self.view addSubview:self.popButton];
}

- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"nav-back-1" target:self action:@selector(popAction)];
        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
        _popButton.layer.cornerRadius = 15;
        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}

- (void)popAction
{
    // 删除用户信息
    [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"user"];
    // 删除token
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
    // 返回上一页
    CZLoginController *vc = [CZLoginController shareLoginController];
    vc.isLogin = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
