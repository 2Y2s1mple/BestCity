//
//  CZRedPacketsWithdrawalView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsWithdrawalView.h"
@interface CZRedPacketsWithdrawalView ()
/** <#注释#> */
@property (nonatomic, strong) UIButton *recoredBtn;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *currentMoneyLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *alipayNicknameLabel;
@end
NSString *moneyCount;
@implementation CZRedPacketsWithdrawalView
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
    NSLog(@"%ld", sender.tag);
    if (sender.tag == 0) {
        moneyCount = @"50";
    } else if (sender.tag == 1) {
        moneyCount = @"100";
    } else {
        moneyCount = @"150";
    }

    if (self.recoredBtn == sender) return;

    sender.selected = YES;
    self.recoredBtn.selected = NO;

    self.recoredBtn = sender;
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    self.currentMoneyLabel.text = [NSString stringWithFormat:@"%@", _model[@"currentMoney"]];

    if ([_model[@"alipayNickname"] length] > 0) {
        self.alipayNicknameLabel.text = _model[@"alipayNickname"];
    }
}
@end
