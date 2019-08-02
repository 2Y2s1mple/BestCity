//
//  CZCZChangeMobileController.m
//  BestCity
//
//  Created by JasonBourne on 2019/2/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCZChangeMobileController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZBindingMobileController.h"
// 工具
#import <TCWebCodesSDK/TCWebCodesBridge.h> // 腾讯验证码

@interface CZCZChangeMobileController ()
/** 当前手机号 */
@property (nonatomic, weak) IBOutlet UILabel
*phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
/** 立即更换 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间总数 */
@property (nonatomic, assign) NSInteger count;
/** 判断是否在读秒 */
@property (nonatomic, assign) BOOL isReadSecond;
@end

@implementation CZCZChangeMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"更换手机号" rightBtnTitle:nil rightBtnAction:nil];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    [self enabledAndRedColor:self.verificationCodeBtn];
    [self.passwordTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    
    // 用户信息
    NSDictionary *userInfo = [CZSaveTool objectForKey:@"user"];
    self.phoneNumber.text = userInfo[@"mobile"];
}

- (void)textFieldAction:(UITextField *)textField
{
    
    if (self.passwordTextField.text.length != 0) {
        [self enabledAndRedColor:self.loginBtn];
    } else {
        [self disabledAndGrayColor:self.loginBtn];
    }
}

#pragma mark - 获取验证码
- (IBAction)getVerificationCode:(id)sender {
    NSDictionary *versionParam = [CZSaveTool objectForKey:requiredVersionCode];
    if ([versionParam[@"needVerify"] isEqualToNumber:@(1)]) {
        [self.view endEditing:YES];
        // 加载腾讯验证码
        [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:self.view appid:@"2087266956" callback:^(NSDictionary *resultJSON) {
            if (0 == [resultJSON[@"ret"] intValue]) {
                [self setupTencentCaptcha:resultJSON];
            } else {
                [CZProgressHUD showProgressHUDWithText:@"验证失败"];
                [CZProgressHUD hideAfterDelay:1.5];
            }
        }];
    } else {
        [self setupTencentCaptcha:@{}];
    }
}

// 获取验证码
- (void)setupTencentCaptcha:(NSDictionary *)paramDic
{
    [self disabledAndGrayColor:self.verificationCodeBtn];
    self.count = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];

    // 发送验证码
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.phoneNumber.text;
    param[@"type"] = @(3); // 3更换手机号

    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/sendMessage"];

    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [CZProgressHUD showProgressHUDWithText:@"验证码发送成功"];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"验证码发送失败"];
        }
        [CZProgressHUD hideAfterDelay:2];
    } failure:^(NSError *error) {

    }];
}

- (void)timeDown
{
    // 是否在读秒
    self.isReadSecond = YES;
    self.count -= 1;
    [self.verificationCodeBtn setTitle:[NSString stringWithFormat:@"%lds后重发", (long)self.count] forState:UIControlStateNormal];
    if (_count == 0) {
        [self.timer invalidate];
        [self enabledAndRedColor:self.verificationCodeBtn];
        [self.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.isReadSecond = NO;
    }
    
}

#pragma mark - 立即更换
- (IBAction)nextAction:(UIButton *)sender {
    sender.enabled = NO;
    // 验证
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"code"] = self.passwordTextField.text;
    
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/validateMobileCode"];
    
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        sender.enabled = YES;
        if ([result[@"msg"] isEqualToString:@"success"]) {
            CZBindingMobileController *vc = [[CZBindingMobileController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"验证码错误"];
        }
        [CZProgressHUD hideAfterDelay:2];
    } failure:^(NSError *error) {
        
    }];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
