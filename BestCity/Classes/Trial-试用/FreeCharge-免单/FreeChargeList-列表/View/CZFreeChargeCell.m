//
//  CZFreeChargeCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell.h"
#import "UIImageView+WebCache.h"
#import "CZFreeAlertView.h"

// 工具
#import "CZUMConfigure.h"

@interface CZFreeChargeCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *invitingNowBtn;
/** <#注释#> */
/** <#注释#> */
@property (nonatomic, assign) BOOL isAnimate;
@end

@implementation CZFreeChargeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeChargeCell";
    CZFreeChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.isAnimate = YES;
//    self.invitingNowBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);

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
               self.invitingNowBtn.transform = CGAffineTransformScale(self.invitingNowBtn.transform, 1.2, 1.2);
               self.isAnimate = NO;
           } else {
               self.invitingNowBtn.transform = CGAffineTransformMakeScale(1, 1);
               self.isAnimate = YES;
           }

       }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** <#注释#> */
- (IBAction)nnvitingNowAction
{
    [[CZFreeAlertView freeAlertViewRightBlock:^(CZFreeAlertView * _Nonnull alertView) {
        [self shareActionWithType:998];
    } leftBlock:^(CZFreeAlertView * _Nonnull alertView) {
        [self shareActionWithType:998];
    }] show];
}

- (void)shareActionWithType:(NSInteger)type
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    [CZProgressHUD showProgressHUDWithText:nil];
    [[CZUMConfigure shareConfigure] shareToPlatformType:UMSocialPlatformType_WechatSession currentViewController:currentVc webUrl:@"" Title:@"" subTitle:@"" thumImage:@"" shareType:type object:@""];
    [CZProgressHUD hideAfterDelay:3.0];
}

@end
