//
//  CZChangeWeChatController.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/9.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZChangeWeChatController.h"
#import "CZNavigationView.h"
#import "DLIDEKeyboardView.h"
#import "GXNetTool.h"
#import "CZProgressHUD.h"
#import "CZUserInfoTool.h"

@interface CZChangeWeChatController ()
/** 输入框 */
@property (nonatomic, strong) UITextField *textfield;
@end

@implementation CZChangeWeChatController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = CZGlobalLightGray;

       if (IsiPhoneX) {
           UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, -22, SCR_WIDTH, 80)];
           v.backgroundColor = CZGlobalWhiteBg;
           [self.view addSubview:v];
       }

       //导航条
       CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"修改微信号" rightBtnTitle:nil rightBtnAction:^{
           // 保存用户信息
           [self saveUserInfo];
       } ];
       navigationView.backgroundColor = [UIColor whiteColor];
       [self.view addSubview:navigationView];



       UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + (IsiPhoneX ? 24 : 0) + 10, SCR_WIDTH, 45)];
       textBackView.backgroundColor = [UIColor whiteColor];
       [self.view addSubview:textBackView];

       UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, SCR_WIDTH - 20, 45)];
       textfield.backgroundColor = [UIColor whiteColor];
       textfield.placeholder = @"请输入微信号";
       textfield.text = self.name;
       textfield.font = [UIFont systemFontOfSize:16];
       textfield.clearButtonMode = UITextFieldViewModeAlways;
       textfield.keyboardType = UIKeyboardTypeDefault;
       [textfield addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
       [DLIDEKeyboardView attachToTextView:textfield];
       [textBackView addSubview:textfield];
       self.textfield = textfield;


    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGB(0xE25838);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 260, 38);
    btn.layer.cornerRadius = 38 / 2.0;
    btn.centerX = SCR_WIDTH / 2.0;
    btn.y = 200;
    [self.view addSubview:btn];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (textField.text.length > 16) {
//        textField.text = [textField.text substringToIndex:16];
    }
}

- (void)saveUserInfo
{
    NSDictionary *param = @{@"wechat" : self.textfield.text};
    [CZUserInfoTool changeUserInfo:param callbackAction:^(NSDictionary *param) {
        // 代理方法更新上一页的用户信息
//        [self.delegate updateUserInfo];

        // 返回上一页
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end
