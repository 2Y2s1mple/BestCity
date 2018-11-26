//
//  CZLoginController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZLoginController.h"
#import "GXNetTool.h"
#import "CZProgressHUD.h"
#import "TSLWebViewController.h"

@interface CZLoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
/** 登录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间总数 */
@property (nonatomic, assign) NSInteger count;
/** 用户协议 */
@property (weak, nonatomic) IBOutlet UILabel *userAgreementLabel;
/** 是否登录 */
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation CZLoginController

#pragma mark - POP到前一页
- (IBAction)popAction:(id)sender {
    UITabBarController *vc = (UITabBarController *)self.nextResponder;
    if (!_isLogin) {
        vc.selectedIndex = 0;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSDictionary *)deleteAllNullValue:(NSDictionary *)dic{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    for (NSString *keyStr in mutableDic.allKeys) {
        if ([[mutableDic objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[mutableDic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}
#pragma mark - 登录
- (IBAction)loginAction:(id)sender {
    
    // 短信登录接口
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.userTextField.text;
    param[@"code"] = self.passwordTextField.text;
  
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/Messagelogin"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyJSON header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"])
        {
            [CZProgressHUD showProgressHUDWithText:@"登录成功"];
            // 是否登录
            self.isLogin = YES;
            [CZProgressHUD hideAfterDelay:2];
            NSDictionary *userDic = [self deleteAllNullValue:result[@"user"]];
            // 存储user, 都TM存储上了
            [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"user"];
            // 储存图片
            [[NSUserDefaults standardUserDefaults] setObject:userDic[@"userNickImg"] forKey:@"userNickImg"];
            // 积分
            [[NSUserDefaults standardUserDefaults] setObject:result[@"points"] forKey:@"point"];
                
            [[NSUserDefaults standardUserDefaults] setObject:result[@"UserAccountEntity"] forKey:@"Account"];
            // 支付宝账号
            [[NSUserDefaults standardUserDefaults] setObject:userDic[@"alipayAccount"] forKey:@"alipayPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:userDic[@"alipayName"] forKey:@"alipayRealName"];
            
            // 登录成功发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:loginChangeUserInfo object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:2];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark - 获取验证码
- (IBAction)getVerificationCode:(id)sender {
//    NSLog(@"getVerificationCode==");
    [self disabledAndGrayColor:self.verificationCodeBtn];
    //将用户text失效
    self.userTextField.enabled = NO;
    self.userTextField.textColor = [UIColor lightGrayColor];
    self.count = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    
    // 发送验证码
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.userTextField.text;
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/pushMessage"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyJSON header:nil response:GXResponseStyleJSON success:^(id result) {
//        NSLog(@"%@", result);
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [CZProgressHUD showProgressHUDWithText:@"验证码发送成功"];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"验证码发送失败"];
        }
        [CZProgressHUD hideAfterDelay:2];
    } failure:^(NSError *error) {}];
}

 - (void)timeDown
{
    self.count -= 1;
    [self.verificationCodeBtn setTitle:[NSString stringWithFormat:@"%lds后重发", (long)self.count] forState:UIControlStateNormal];
    if (_count == 0) {
        [self.timer invalidate];
        [self enabledAndRedColor:self.verificationCodeBtn];
        //将用户text激活
        self.userTextField.enabled = YES;
         self.userTextField.textColor = [UIColor blackColor];
        [self.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.userTextField.text = @"13841284944";
    //代理方法监听时候都会慢一步
    [self.userTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    
    // 跳转用户协议
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userAgreement)];
    [self.userAgreementLabel addGestureRecognizer:tap];
    self.userAgreementLabel.userInteractionEnabled = YES;
}

/** 跳转用户协议 */
- (void)userAgreement
{
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:UserAgreement_url]];
    webVc.titleName = @"用户协议";
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldAction:(UITextField *)textField
{
    if (self.userTextField.text.length != 0 && self.passwordTextField.text.length != 0 ) {
        [self enabledAndRedColor:self.loginBtn];
    } else {
        [self disabledAndGrayColor:self.loginBtn];
    }
    
    if (self.userTextField == textField) {
        if (self.userTextField.text.length == 11) {
            [self enabledAndRedColor:self.verificationCodeBtn];
        } else {
            [self disabledAndGrayColor:self.verificationCodeBtn];
        }
    }
}

//键盘Return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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

@end
