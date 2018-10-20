//
//  CZChangeNicknameController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/2.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZChangeNicknameController.h"
#import "CZNavigationView.h"
#import "CZTextField.h"
#import "DLIDEKeyboardView.h"
#import "GXNetTool.h"
#import "CZProgressHUD.h"
#import "CZUserInfoTool.h"

@interface CZChangeNicknameController ()
/** 输入框 */
@property (nonatomic, strong) CZTextField *textfield;
@end

@implementation CZChangeNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalLightGray;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"昵称" rightBtnTitle:@"保存" rightBtnAction:^{
        // 保存用户信息
        [self saveUserInfo];

    } navigationViewType:CZNavigationViewTypeBlack];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    CZTextField *textfield = [[CZTextField alloc] initWithFrame:CGRectMake(0, 68, SCR_WIDTH, 40)];
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.text = self.name;
    textfield.font = [UIFont systemFontOfSize:16];
    textfield.clearButtonMode = UITextFieldViewModeAlways;
    textfield.keyboardType = UIKeyboardTypeDefault;
    [DLIDEKeyboardView attachToTextView:textfield];
    [self.view addSubview:textfield];
    self.textfield = textfield;

}

- (void)saveUserInfo
{
    NSDictionary *param = @{@"userNickName" : self.textfield.text};
    [CZUserInfoTool changeUserInfo:param callbackAction:^(NSDictionary *param) {
        // 代理方法更新上一页的用户信息
        [self.delegate updateUserInfo];
        
        // 返回上一页
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



@end
