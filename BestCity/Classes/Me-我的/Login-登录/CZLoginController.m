//
//  CZLoginController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZLoginController.h"
#import "GXNetTool.h"

#import "CZMeController.h"
#import "CZSettingController.h"
#import "CZDestroyAlertController.h"

// 一键登录
#import "CZJVerificationHandler.h"
#import "CZSubButton.h"
#import "CZBindingController.h"
#import "JVERIFICATIONService.h"

#import "CZMobileLoginController.h"


@interface CZLoginController ()<UITextFieldDelegate>
/** <#注释#> */
@property (nonatomic, strong) UILabel *userAgreementLabel;
@end

static id instancet_;
@implementation CZLoginController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
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
    if ([currentVc.topViewController isKindOfClass:[CZDestroyAlertController class]]) {
        [currentVc popToRootViewControllerAnimated:NO];
        vc.selectedIndex = 0;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 微信登录
- (IBAction)logininWithWxin
{
    [[CZJVerificationHandler shareJVerificationHandler] preLogin:^(BOOL success) {
        if (success) {
            [self wxinAuth:YES];
        } else {
            [self wxinAuth:NO];
        }
    }];
}

- (void)wxinAuth:(BOOL)isMobile
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
            if ([result[@"code"] isEqualToNumber:@(700)]) {
                if (isMobile) {
                    [self bindingMobileWithWechatOpenid:param[@"openid"]];
                } else {
                    CZBindingController *vc = [[CZBindingController alloc] init];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    vc.openid = param[@"openid"];
                    [self presentViewController:vc animated:NO completion:nil];
                }
            } else if ([result[@"code"] isEqualToNumber:@(0)]) {
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

// 绑定手机
- (void)bindingMobileWithWechatOpenid:(NSString *)openid
{
    [[CZJVerificationHandler shareJVerificationHandler] JAuthBindingWithController:self action:^(NSString * _Nonnull loginToken) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"channel"] = @(1); // 渠道(1微信，2微博)
        param[@"loginToken"] = loginToken;
        param[@"openid"] = openid;
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/bindMobileOnce"];
        [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(NSDictionary *result) {
            if ([result[@"code"] isEqual:@(0)]) {
                [CZProgressHUD showProgressHUDWithText:@"绑定成功"];
                [CZProgressHUD hideAfterDelay:1.5];
                // 用户数据
                NSDictionary *userDic = [result[@"data"] deleteAllNullValue];
                // 存储token
                [CZSaveTool setObject:userDic[@"token"] forKey:@"token"];
                // 存储用户信息, 都TM存储上了
                [CZSaveTool setObject:userDic forKey:@"user"];

               // 登录成功发送通知
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:loginChangeUserInfo object:nil];
                });
            } else {
                
            }
        } failure:nil];
    }];
}


#pragma mark - 登录
- (IBAction)loginAction:(id)sender {
    [[CZJVerificationHandler shareJVerificationHandler] JAuthorizationWithController:self action:^(NSString * _Nonnull loginToken) {
        if (loginToken.length == 0) {
            CZMobileLoginController *vc = [[CZMobileLoginController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            // 要关注对象ID
            param[@"loginToken"] = loginToken;
            NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/signOnce"];
            [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(NSDictionary *result) {
                if ([result[@"msg"] isEqualToString:@"success"]) {
                    [CZProgressHUD showProgressHUDWithText:@"登录成功"];
                    [CZProgressHUD hideAfterDelay:1.5];
                    // 用户数据
                    NSDictionary *userDic = [result[@"data"] deleteAllNullValue];
                    // 存储token
                    [CZSaveTool setObject:userDic[@"token"] forKey:@"token"];
                    // 存储用户信息, 都TM存储上了
                    [CZSaveTool setObject:userDic forKey:@"user"];
                    
                    // 登录成功发送通知
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:loginChangeUserInfo object:nil];
                    });
                } else {
                    
                }
            } failure:nil];
        }
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
