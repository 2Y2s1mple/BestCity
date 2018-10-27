//
//  CZCreditorController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCreditorController.h"
#import "CZNavigationView.h"
#import "DLIDEKeyboardView.h"
#import "GXNetTool.h"

@interface CZCreditorController ()<UITextViewDelegate>
/** 支付宝账号 */
@property (nonatomic, weak) IBOutlet UITextField *alipaynName;
/** 支付宝真名 */
@property (nonatomic, weak) IBOutlet UITextField *realName;
/** 保存按钮 */
@property (nonatomic, weak) IBOutlet UIButton *saveBtn;

@end

@implementation CZCreditorController

- (IBAction)didClickedBtn:(UIButton *)sender
{
    // 修改支付宝账号
    [self changeUserInfo:@{@"alipayName" : self.realName.text, @"alipayAccount" : self.alipaynName.text}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"收款账户" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    // 设置输入框键盘
    [DLIDEKeyboardView attachToTextView:self.alipaynName];
    [DLIDEKeyboardView attachToTextView:self.realName];
    
    // 代理方法监听时候都会慢一步
    [self.alipaynName addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.realName addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldAction:(UITextField *)textField
{
    if (self.alipaynName.text.length != 0 && self.realName.text.length != 0) {
        // 激活
        [self enabledAndRedColor:self.saveBtn];
    } else {
        // 残疾
        [self disabledAndGrayColor:self.saveBtn];
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

#pragma mark - 修改用户信息
- (void)changeUserInfo:(NSDictionary *)info
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"userId" : USERINFO[@"userId"]}];
    [param addEntriesFromDictionary:info];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/ModelUserUpdate"];
    
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        
//        NSLog(@"result ----- %@", result);
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 保存支付宝信息
            [[NSUserDefaults standardUserDefaults] setObject:self.alipaynName.text forKey:@"alipayPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:self.realName.text forKey:@"alipayRealName"];
            [CZProgressHUD showProgressHUDWithText:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate updateData];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"绑定失败"];
        }
        [CZProgressHUD hideAfterDelay:2];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
