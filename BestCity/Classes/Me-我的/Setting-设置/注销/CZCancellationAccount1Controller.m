//
//  CZCancellationAccount1Controller.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/15.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZCancellationAccount1Controller.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
// 工具
#import <TCWebCodesSDK/TCWebCodesBridge.h> // 腾讯验证码
#import "CZDestroyAlertController.h"

@interface CZCancellationAccount1Controller () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间总数 */
@property (nonatomic, assign) NSInteger count;
/** 判断是否在读秒 */
@property (nonatomic, assign) BOOL isReadSecond;
/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation CZCancellationAccount1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"验证手机号" rightBtnTitle:@"" rightBtnAction:nil];
    [self.view addSubview:navigationView];
    
    //代理方法监听时候都会慢一步
    [self.userTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    
}

- (IBAction)getVerificationCode:(id)sender {
    NSDictionary *versionParam = [CZSaveTool objectForKey:requiredVersionCode];
    if ([versionParam[@"needVerify"] isEqual:@(1)]) {
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
    param[@"mobile"] = self.userTextField.text;
    param[@"type"] = @(1); // 1代表登录验证码
    param[@"ticket"] = paramDic[@"ticket"];
    param[@"randstr"] = paramDic[@"randstr"];

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
        //将用户text激活
        self.userTextField.enabled = YES;
         self.userTextField.textColor = [UIColor blackColor];
        [self.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.isReadSecond = NO;
    }
}



- (void)textFieldAction:(UITextField *)textField
{
    if (self.userTextField.text.length != 0 && self.passwordTextField.text.length != 0 ) {
        [self enabledAndRedColor:self.loginBtn];
    } else {
        [self disabledAndGrayColor:self.loginBtn];
    }
    
    if (self.userTextField == textField) {
        if (self.userTextField.text.length > 11) {
            self.userTextField.text = [self.userTextField.text substringToIndex:11];
        }
        if (self.userTextField.text.length == 11 && !self.isReadSecond) {
            [self enabledAndRedColor:self.verificationCodeBtn];
        } else {
            [self disabledAndGrayColor:self.verificationCodeBtn];
        }
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


#pragma mark - 提交
- (IBAction)submitAction:(id)sender {
    
    // 短信登录接口
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.userTextField.text;
    param[@"code"] = self.passwordTextField.text;
  
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/destroyAccount"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)])
        {
            CZDestroyAlertController *vc = [[CZDestroyAlertController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:2];
        }
        
    } failure:^(NSError *error) {}];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

@end
