//
//  CZBindingMobileController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/8.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZBindingMobileController.h"
#import "CZNavigationView.h"

@interface CZBindingMobileController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
/** 立即更换 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间总数 */
@property (nonatomic, assign) NSInteger count;
@end

@implementation CZBindingMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"绑定手机" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    //代理方法监听时候都会慢一步
    [self.userTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 立即更换
- (IBAction)loginAction:(id)sender {
    NSLog(@"%s", __func__);
}

#pragma mark - 获取验证码
- (IBAction)getVerificationCode:(id)sender {
    [self disabledAndGrayColor:self.verificationCodeBtn];
    //将用户text失效
    self.userTextField.enabled = NO;
    self.count = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
}

- (void)timeDown
{
    self.count -= 1;
    [self.verificationCodeBtn setTitle:[NSString stringWithFormat:@"%lds后重发", self.count] forState:UIControlStateNormal];
    if (_count == 55) {
        [self.timer invalidate];
        [self enabledAndRedColor:self.verificationCodeBtn];
        //将用户text激活
        self.userTextField.enabled = YES;
        [self.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)textFieldAction:(UITextField *)textField
{
    if (self.userTextField.text.length != 0 && self.passwordTextField.text.length != 0 ) {
        [self enabledAndRedColor:self.loginBtn];
    } else {
        [self disabledAndGrayColor:self.loginBtn];
    }
    
    if (self.userTextField.text.length == 1) {
        [self enabledAndRedColor:self.verificationCodeBtn];
    } else {
        [self disabledAndGrayColor:self.verificationCodeBtn];
    }
}

/** 激活红色 */
- (void)enabledAndRedColor:(UIButton *)btn
{
    btn.backgroundColor = CZREDCOLOR;
    btn.enabled = YES;
}
/** 残疾灰色 */
- (void)disabledAndGrayColor:(UIButton *)btn
{
    btn.backgroundColor = CZBTNGRAY;
    btn.enabled = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
