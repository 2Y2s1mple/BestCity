//
//  CZRedPacketsWithdrawalView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsWithdrawalView.h"
#import "CZRWBindingController.h"

@interface CZRedPacketsWithdrawalView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *btn1;
/** <#注释#> */
@property (nonatomic, strong) UIButton *recoredBtn;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *currentMoneyLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *alipayNicknameLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UITextField *textField;
@end
NSString *moneyCount = @"50";
@implementation CZRedPacketsWithdrawalView

- (void)awakeFromNib
{
    [super awakeFromNib];
    //代理方法监听时候都会慢一步
    [self.textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
}

+ (instancetype)redPacketsWithdrawalView
{
    CZRedPacketsWithdrawalView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.width = SCR_WIDTH;
    return view;
}

/** 提现记录 */
- (IBAction)recoredWithdrawal
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *vc = nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZRedWithdrawalRecordController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

// 提现金额
- (IBAction)WithdrawalAmount:(UIButton *)sender
{
    self.textField.text = [NSString stringWithFormat:@"%@", _model[@"currentMoney"]];
     moneyCount = self.textField.text;
}

- (void)textFieldAction:(UITextField *)textField
{
    moneyCount = textField.text;
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    self.currentMoneyLabel.text = [NSString stringWithFormat:@"%@", _model[@"currentMoney"]];

    if ([_model[@"alipayNickname"] length] > 0) {
        self.alipayNicknameLabel.text = _model[@"alipayNickname"];
    }
}

// 绑定提现
- (IBAction)bingzhifubao
{
    if ([self.model[@"realname"] length] == 0 || [self.model[@"alipayNickname"] length] == 0) {
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        UINavigationController *nav = tabbar.selectedViewController;
        UIViewController *vc = nav.topViewController;
        CZRWBindingController *toVc = [[CZRWBindingController alloc] init];
        toVc.model = self.model;
        [vc.navigationController pushViewController:toVc animated:YES];
    }
}
@end
