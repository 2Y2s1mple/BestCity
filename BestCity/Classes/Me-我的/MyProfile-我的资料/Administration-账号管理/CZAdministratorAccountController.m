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
    
    // 用户信息
    NSDictionary *userInfo = [CZSaveTool objectForKey:@"user"];
    self.phoneLabel.text = userInfo[@"mobile"];
    if ([userInfo[@"bindWeixin"]  isEqual: @"1"]) { // 已绑定
        [self.weixinChangeBtn setBackgroundColor:CZREDCOLOR];
        [self.weixinChangeBtn setTitle:@"已绑定" forState:UIControlStateNormal];
        [self.weixinChangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self.weixinChangeBtn setBackgroundColor:[UIColor whiteColor]];
        [self.weixinChangeBtn setTitle:@"去绑定" forState:UIControlStateNormal];
        [self.weixinChangeBtn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    }
        
}

- (IBAction)changePhoneNumber
{
    CZCZChangeMobileController *vc = [[CZCZChangeMobileController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
