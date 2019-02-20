//
//  CZAdministratorAccountController.m
//  BestCity
//
//  Created by JasonBourne on 2019/2/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAdministratorAccountController.h"
#import "CZNavigationView.h"
#import "CZSaveTool.h"
#import "CZCZChangeMobileController.h"
#import "CZUserInfoTool.h"
#import <UMShare/UMShare.h>
#import "GXNetTool.h"
#import "CZMyProfileController.h"

@interface CZAdministratorAccountController ()
/** 手机号更换按钮 */
@property (nonatomic, weak) IBOutlet UIButton *numberChangeBtn;
/** 手机号 */
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
/** 微信更换按钮 */
@property (nonatomic, weak) IBOutlet UIButton *weixinChangeBtn;
@end

@implementation CZAdministratorAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"账号管理" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserInfo];
}


#pragma mark - 获取用户信息
- (void)getUserInfo
{
    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {
        // 用户信息
        NSDictionary *userInfo = [CZSaveTool objectForKey:@"user"];
        self.phoneLabel.text = userInfo[@"mobile"];
        if ([userInfo[@"bindWeixin"]  isEqual: @(1)]) { // 已绑定
            [self.weixinChangeBtn setBackgroundColor:[UIColor whiteColor]];
            [self.weixinChangeBtn setTitle:@"已绑定" forState:UIControlStateNormal];
            [self.weixinChangeBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
            self.weixinChangeBtn.layer.borderColor = CZGlobalGray.CGColor;
        } else {
            [self.weixinChangeBtn setBackgroundColor:CZREDCOLOR];
            [self.weixinChangeBtn setTitle:@"去绑定" forState:UIControlStateNormal];
            [self.weixinChangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.weixinChangeBtn.layer.borderColor = CZREDCOLOR.CGColor;
        }
    }];
}


- (IBAction)changePhoneNumber
{
    CZCZChangeMobileController *vc = [[CZCZChangeMobileController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)bingWeixin
{
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        UMSocialShareResponse *resp = result;
        NSLog(@"authWithPlatform -  %@", resp.originalResponse);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"accessToken"] =  resp.originalResponse[@"access_token"];
        param[@"openid"] = resp.originalResponse[@"openid"];
        param[@"channel"] = @(1);
        
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/bindThirdAccount"];
        [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"code"] isEqualToNumber:@(0)]){
                [CZProgressHUD showProgressHUDWithText:@"绑定成功"];
                [CZProgressHUD hideAfterDelay:1.5];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[CZMyProfileController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
            
        } failure:^(NSError *error) {}];
    }];
}

@end
