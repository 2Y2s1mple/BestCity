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
#import "CZScrollAD.h"
#import "CZRedPacketsWithdrawalController.h"

@interface CZRedPacketsView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *invitationCodeLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *currentMoneyLabel;
/** 累计获得红包 */
@property (nonatomic, weak) IBOutlet UILabel *totalMoneyLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *teamCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teamCountLabelMargin;


/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *image1;
@property (nonatomic, weak) IBOutlet UIImageView *image2;
@property (nonatomic, weak) IBOutlet UIImageView *image3;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *bottomView;

/** <#注释#> */
@property (nonatomic, assign) NSInteger shareCount;

@property (nonatomic, weak) IBOutlet CZScrollAD *HotStyleTop; // 第一个轮播图载体

/** 未登录状态 */
@property (nonatomic, weak) IBOutlet UIView *noLoginView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
/** 立即提现 */
@property (nonatomic, weak) IBOutlet UIButton *btn;
/** 立即提现提示 */
@property (nonatomic, weak) IBOutlet UILabel *label3;
/** 我的好友 */
@property (nonatomic, weak) IBOutlet UIView *myFriendView;


/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *invitingNowBtn;

/** <#注释#> */
@property (nonatomic, assign) BOOL isAnimate;

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

    self.HotStyleTop.dataSource = _model[@"messageList"];

    self.totalMoneyLabel.text = [NSString stringWithFormat:@"累计获得现金红%.2f元", [_model[@"totalMoney"] floatValue]];
    // 团队数量
    self.teamCountLabel.text = [NSString stringWithFormat:@"等%ld人加入我的团队", [_model[@"avatarList"] count]];

    for (int i = 0; i < [_model[@"avatarList"] count]; i++) {
        switch (i) {
            case 0:
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:_model[@"avatarList"][i]]];
                self.teamCountLabelMargin.constant = -(33 + 33 - 20);
                break;
            case 1:
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:_model[@"avatarList"][i]]];
                self.teamCountLabelMargin.constant = -(33 - 10);
                break;
            case 2:
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:_model[@"avatarList"][i]]];
                self.teamCountLabelMargin.constant = 0;
                break;
            default:
                break;
        }
    }


    if ([_model[@"avatarList"] count] == 0) {
        self.myFriendView.hidden = NO;
    } else {
        self.myFriendView.hidden = YES;
    }

    self.height = CZGetY(self.bottomView);

    [self layoutIfNeeded];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.HotStyleTop.type = 333;
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self scaleImageView];
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)scaleImageView
{
    [UIView animateWithDuration:1.5 animations:^{
        if (self.isAnimate) {
            self.invitingNowBtn.transform = CGAffineTransformScale(self.invitingNowBtn.transform, 1.1, 1.1);
            self.isAnimate = NO;
        } else {
            self.invitingNowBtn.transform = CGAffineTransformMakeScale(1, 1);
            self.isAnimate = YES;
        }
    }];
}


- (IBAction)activityRules
{
    CURRENTVC(currentVc);
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/xianjin_rule.html"]];
    webVc.titleName = @"活动规则";
    [currentVc presentViewController:webVc animated:YES completion:nil];
}

/** 复制到剪切板 */
- (IBAction)generalPaste
{
    if (_isNoLogin) {
        CZLoginController *vc = [[CZLoginController alloc] init];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        UINavigationController *nav = tabbar.selectedViewController;
        UIViewController *currentVc = nav.topViewController;
        [nav presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *text = @"我的--点击复制（邀请码）";
        NSDictionary *context = @{@"mine" : text};
        [MobClick event:@"ID5" attributes:context];

        UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
        posteboard.string = JPUSERINFO[@"invitationCode"];
        [CZProgressHUD showProgressHUDWithText:@"复制成功"];
        [CZProgressHUD hideAfterDelay:1.5];
        [recordSearchTextArray addObject:posteboard.string];
    }
}

/** 立即提现 */
- (IBAction)ImmediateWithdrawal
{
    if (_isNoLogin) {
        CZLoginController *vc = [[CZLoginController alloc] init];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        UINavigationController *nav = tabbar.selectedViewController;
        UIViewController *currentVc = nav.topViewController;
        [nav presentViewController:vc animated:YES completion:nil];
    } else {
        NSLog(@"立即提现");
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        UINavigationController *nav = tabbar.selectedViewController;
        UIViewController *vc = nav.topViewController;
        CZRedPacketsWithdrawalController *toVc = [[CZRedPacketsWithdrawalController alloc] init];
        toVc.model = _model;
        [vc.navigationController pushViewController:toVc animated:YES];
    }
}

/** 立即邀请 */
- (IBAction)ImmediatelyInvited
{
    NSLog(@"立即邀请");
    if (self.shareCount == 0) {
        self.shareCount++;
        [CZProgressHUD showProgressHUDWithText:nil];
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/user/getShareInfo"];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                CZRedPacketsShareView *view = [[CZRedPacketsShareView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
                view.paramDic = result[@"data"];
                [[UIApplication sharedApplication].keyWindow addSubview:view];
            }
            [CZProgressHUD hideAfterDelay:0.15];
            self.shareCount = 0;
        } failure:^(NSError *error) {}];
    }
}

/** 前往查看 */
- (IBAction)voteBtnAction:(UIButton *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *vc = nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZMeTeamMembersController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

// 判断是否登录
- (void)setIsNoLogin:(BOOL)isNoLogin
{
    _isNoLogin = isNoLogin;
    if (_isNoLogin) { // 未登录
        self.noLoginView.hidden = NO;
        self.invitationCodeLabel.hidden = YES;
        self.label1.hidden = YES;
        self.label2.hidden = YES;
        self.label3.text = @"登陆后领取现金红包";
        [self.btn setTitle:@"立即登录" forState:UIControlStateNormal];
        self.myFriendView.hidden = NO;
    } else {
        self.noLoginView.hidden = YES;
        self.invitationCodeLabel.hidden = NO;
        self.label1.hidden = NO;
        self.label2.hidden = NO;
        self.label3.text = @"邀请好友奖励可以立即提现";
        [self.btn setTitle:@"立即提现" forState:UIControlStateNormal];
        self.myFriendView.hidden = YES;
    }
}

@end
