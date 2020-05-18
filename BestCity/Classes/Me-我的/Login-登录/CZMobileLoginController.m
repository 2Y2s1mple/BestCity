//
//  CZAKeyToLoginController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/18.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMobileLoginController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZBindingController.h"
// 工具
#import <TCWebCodesSDK/TCWebCodesBridge.h> // 腾讯验证码"


@interface CZMobileLoginController () <UITextFieldDelegate>
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

@implementation CZMobileLoginController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"手机号登录" rightBtnTitle:@"" rightBtnAction:nil];
    [self.view addSubview:navigationView];
    
    //代理方法监听时候都会慢一步
    [self.userTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    
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
            [self.verificationCodeBtn setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
        } else {
            [self.verificationCodeBtn setTitleColor:CZBTNGRAY forState:UIControlStateNormal];
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

#pragma mark - 微信登录
- (IBAction)logininWithWxin
{
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        UMSocialShareResponse *resp = result;
        NSLog(@"authWithPlatform -  %@", resp.originalResponse);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"accessToken"] =  resp.originalResponse[@"access_token"];
        param[@"openid"] = resp.originalResponse[@"openid"];
        param[@"channel"] = @(1);
        
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/thirdLogin"];
        [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"code"] isEqualToNumber:@(700)])
            {
                CZBindingController *vc = [[CZBindingController alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                vc.openid = param[@"openid"];
                [self presentViewController:vc animated:NO completion:nil];
            } else if ([result[@"code"] isEqualToNumber:@(0)]){
                [CZProgressHUD showProgressHUDWithText:@"登录成功"];
                [CZProgressHUD hideAfterDelay:1];
                // 用户数据
                NSDictionary *userDic = [result[@"data"] deleteAllNullValue];
                // 存储token
                [CZSaveTool setObject:userDic[@"token"] forKey:@"token"];
                // 存储用户信息, 都TM存储上了
                [CZSaveTool setObject:userDic forKey:@"user"];
                // 登录成功发送通知
                [self dismissViewControllerAnimated:NO completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:loginChangeUserInfo object:nil];
                }];
            }
            
        } failure:^(NSError *error) {}];
    }];
    
}

#pragma mark - 登录
- (IBAction)loginAction:(id)sender {
    // 短信登录接口
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"mobile"] = self.userTextField.text;
    param[@"code"] = self.passwordTextField.text;
//    param[@"invitationCode"] = self.inviteTextField.text;
  
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/mobileLogin"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)])
        {
            [CZProgressHUD showProgressHUDWithText:@"登录成功"];
            // 是否登录
//            self.isLogin = YES;
            [CZProgressHUD hideAfterDelay:2];
            // 用户数据
            NSDictionary *userDic = [result[@"data"] deleteAllNullValue];
            // 存储token
            [CZSaveTool setObject:userDic[@"token"] forKey:@"token"];
            // 存储用户信息, 都TM存储上了
            [CZSaveTool setObject:userDic forKey:@"user"];
            // 删除账号密码
            self.userTextField.text = nil;
            self.passwordTextField.text = nil;
            
            // 登录成功发送通知
            [self dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:loginChangeUserInfo object:nil];
            }];
            
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:2];
        }
        
    } failure:^(NSError *error) {}];
}

#pragma mark - 获取验证码
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
    [self.verificationCodeBtn setTitleColor:CZBTNGRAY forState:UIControlStateNormal];
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
        [self.verificationCodeBtn setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
        //将用户text激活
        self.userTextField.enabled = YES;
         self.userTextField.textColor = [UIColor blackColor];
        [self.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.isReadSecond = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/** 跳转用户协议 */
- (IBAction)userAgreement
{
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:UserAgreement_url]];
    webVc.titleName = @"极品城用户协议";
    [self presentViewController:webVc animated:YES completion:nil];
}

/** 隐私协议 */
- (IBAction)userPrivacy
{
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:UserPrivacy_url]];
    webVc.titleName = @"隐私政策";
    [self presentViewController:webVc animated:YES completion:nil];
}

@end
