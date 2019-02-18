//
//  CZChangeNicknameController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/2.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZChangeNicknameController.h"
#import "CZNavigationView.h"
#import "DLIDEKeyboardView.h"
#import "GXNetTool.h"
#import "CZProgressHUD.h"
#import "CZUserInfoTool.h"

@interface CZChangeNicknameController ()
/** 输入框 */
@property (nonatomic, strong) UITextField *textfield;
@end

@implementation CZChangeNicknameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalLightGray;
    
    if (IsiPhoneX) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, -22, SCR_WIDTH, 80)];
        v.backgroundColor = CZGlobalWhiteBg;
        [self.view addSubview:v];
    }
    
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"昵称" rightBtnTitle:@"保存" rightBtnAction:^{
        // 保存用户信息
        [self saveUserInfo];

    } navigationViewType:CZNavigationViewTypeBlack];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    
    
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, 40)];
    textBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textBackView];
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, SCR_WIDTH - 20, 40)];
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.text = self.name;
    textfield.font = [UIFont systemFontOfSize:16];
    textfield.clearButtonMode = UITextFieldViewModeAlways;
    textfield.keyboardType = UIKeyboardTypeDefault;
    [textfield addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [DLIDEKeyboardView attachToTextView:textfield];
    [textBackView addSubview:textfield];
    self.textfield = textfield;

}

- (void)textFieldChange:(UITextField *)textField
{
    if (textField.text.length > 16) {
        textField.text = [textField.text substringToIndex:16];
    }
}


- (void)saveUserInfo
{
    NSDictionary *param = @{@"nickname" : self.textfield.text};
    [CZUserInfoTool changeUserInfo:param callbackAction:^(NSDictionary *param) {
        // 代理方法更新上一页的用户信息
        [self.delegate updateUserInfo];
        
        // 返回上一页
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



@end
