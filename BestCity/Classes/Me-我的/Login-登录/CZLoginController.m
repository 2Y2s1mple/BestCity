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
#import <UMShare/UMShare.h>
#import "CZBindingController.h"
#import "CZUpdataView.h"

#import "CZMeController.h"
#import "CZSettingController.h"
#import "CZSubFreeChargeController.h" // 新人专区

// 工具
#import <TCWebCodesSDK/TCWebCodesBridge.h> // 腾讯验证码

@interface CZLoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/** 邀请码 */
@property (nonatomic, weak) IBOutlet UITextField *inviteTextField;
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

/** 判断是否在读秒 */
@property (nonatomic, assign) BOOL isReadSecond;

/** <#注释#> */
@property (nonatomic, assign) NSInteger recoredClickedCount;

@end

static id instancet_;
@implementation CZLoginController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

+ (instancetype)shareLoginController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancet_ = [[CZLoginController alloc] init];
        [instancet_ setModalPresentationStyle:(UIModalPresentationFullScreen)];
    });
    return instancet_;
}

#pragma mark - POP到前一页
- (IBAction)popAction:(id)sender {
    UITabBarController *vc = (UITabBarController *)self.nextResponder;
    UINavigationController *currentVc = [vc.viewControllers objectAtIndex:vc.selectedIndex];
    if ([currentVc.topViewController isKindOfClass:[CZMeController class]]) {
        vc.selectedIndex = 0;
    }
    if ([currentVc.topViewController isKindOfClass:[CZSettingController class]]) {
        [currentVc popToRootViewControllerAnimated:NO];
        vc.selectedIndex = 0;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:loginChangeUserInfo object:nil];
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
    param[@"invitationCode"] = self.inviteTextField.text;
  
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/mobileLogin"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)])
        {
            [CZProgressHUD showProgressHUDWithText:@"登录成功"];
            // 是否登录
            self.isLogin = YES;
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
            [[NSNotificationCenter defaultCenter] postNotificationName:loginChangeUserInfo object:nil];
            // 新人
//            [JPUSERINFO[@"isNewUser"] isEqual:@(0)];
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
    
    // 接收登录时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissViewController) name:loginChangeUserInfo object:nil];

}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

/** 跳转用户协议 */
- (void)userAgreement
{
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:UserAgreement_url]];
    webVc.titleName = @"用户协议";
    [self presentViewController:webVc animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    return;
    self.recoredClickedCount++;
    NSLog(@"-----");
    if (self.recoredClickedCount == 15 && ![JPSERVER_URL  isEqual: @"http://192.168.1.84:8081/qualityshop-api/"]) {
        NSLog(@"----------- 15下");
        self.recoredClickedCount = 0;
        JPSERVER_URL = @"http://192.168.1.84:8081/qualityshop-api/";
        [CZProgressHUD showProgressHUDWithText:@"切换测试地址"];
        [CZProgressHUD hideAfterDelay:2.5];
        [CZSaveTool setObject:JPSERVER_URL forKey:@"currentPath"];
    }
    if (self.recoredClickedCount == 20 && ![JPSERVER_URL  isEqual: @"https://www.jipincheng.cn/qualityshop-api/"]){
        self.recoredClickedCount = 0;
        JPSERVER_URL = @"https://www.jipincheng.cn/qualityshop-api/";
        [CZProgressHUD showProgressHUDWithText:@"切换正式地址"];
        [CZProgressHUD hideAfterDelay:2.5];
        [CZSaveTool setObject:JPSERVER_URL forKey:@"currentPath"];
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


- (void)loadUserAlert
{
    [CZJIPINSynthesisTool jipin_loadAlertView];
}

@end
