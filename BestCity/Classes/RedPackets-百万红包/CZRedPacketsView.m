//
//  CZRedPacketsView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/19.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsView.h"
#import "UIImageView+WebCache.h"
#import "CZRedPacketsShareView.h"
#import "GXNetTool.h"

@interface CZRedPacketsView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *invitationCodeLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *currentMoneyLabel;
/** 累计获得红包 */
@property (nonatomic, weak) IBOutlet UILabel *totalMoneyLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *teamCountLabel;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *image1;
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@end

@implementation CZRedPacketsView

+ (instancetype)redPacketsView
{
    CZRedPacketsView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.width = SCR_WIDTH;
    return view;
}

- (void)setModel:(NSDictionary *)model
{
    _model = [model deleteAllNullValue];

    self.invitationCodeLabel.text = _model[@"invitationCode"];
    self.currentMoneyLabel.text = [NSString stringWithFormat:@"%@", _model[@"currentMoney"]];

    self.totalMoneyLabel.text = [NSString stringWithFormat:@"累计获得现金红%.2f元", [_model[@"totalMoney"] floatValue]];
    // 团队数量
    self.teamCountLabel.text = [NSString stringWithFormat:@"等%ld人加入我的团队", [_model[@"avatarList"] count]];

    for (int i = 0; i < [_model[@"avatarList"] count]; i++) {
        switch (i) {
            case 0:
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:_model[@"avatarList"][i]]];
                break;
            case 1:
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:_model[@"avatarList"][i]]];
                break;
            case 2:
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:_model[@"avatarList"][i]]];
                break;
            default:
                break;
        }
    }

    self.height = CZGetY(self.bottomView);

    [self layoutIfNeeded];
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
    [CZProgressHUD showProgressHUDWithText:nil];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/user/getShareInfo"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            CZRedPacketsShareView *view = [[CZRedPacketsShareView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
            [[UIApplication sharedApplication].keyWindow addSubview:view];
        }
        [CZProgressHUD hideAfterDelay:0.15];
    } failure:^(NSError *error) {

    }];

}

/** 前往查看 */
- (IBAction)voteBtnAction:(UIButton *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *vc = nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZMeTeamMembersController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}
@end
