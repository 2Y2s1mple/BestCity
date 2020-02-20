//
//  CZRedPacketsView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/19.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsView.h"

@interface CZRedPacketsView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *invitationCodeLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *currentMoneyLabel;

@end

@implementation CZRedPacketsView

+ (instancetype)redPacketsView
{
    CZRedPacketsView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.width = SCR_WIDTH;
//    view.height = 364 + 33;
    return view;
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    self.invitationCodeLabel.text = model[@"invitationCode"];
    self.currentMoneyLabel.text = [NSString stringWithFormat:@"%@", model[@"currentMoney"]];

}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

/** 复制到剪切板 */
- (IBAction)generalPaste
{
    NSString *text = @"我的--点击复制（邀请码）";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];

    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = JPUSERINFO[@"invitationCode"];
    [CZProgressHUD showProgressHUDWithText:@"复制成功"];
    [CZProgressHUD hideAfterDelay:1.5];
}

/** 立即提现 */
- (IBAction)ImmediateWithdrawal
{
    NSLog(@"立即提现");
}

/** 立即邀请 */
- (IBAction)ImmediatelyInvited
{
    NSLog(@"立即邀请");
}
@end
