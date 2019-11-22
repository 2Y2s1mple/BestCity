//
//  CZMeArrowCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMeArrowCell.h"
#import "CZMeController.h"
#import "CZSubFreeChargeController.h"
#import "CZFreeAlertView4.h"

@interface CZMeArrowCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *personalityNewView;
@property (nonatomic, weak) IBOutlet UIView *inviteView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personalityNewViewLeftMargin;


@end

@implementation CZMeArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"meArrowCell";
    CZMeArrowCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZMeArrowCell class]) owner:nil options:nil] lastObject];
    }
    if (indexPath.row == 0) {
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 40, 60) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer  alloc]  init];
//        maskLayer.frame = cell.bounds;
//        maskLayer.path = maskPath.CGPath;
//        cell.layer.mask = maskLayer;
    } else if (indexPath.row == 6) {
//        UIBezierPath *bezierPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 40, 60) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *mask = [[CAShapeLayer alloc] init];
//        mask.frame = cell.bounds;
//        mask.path = bezierPath.CGPath;
//        cell.layer.mask = mask;
    }
    return cell;
}

- (void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
   if ([JPUSERINFO[@"pid"] integerValue] != 0) {
       self.inviteView.hidden = YES;
   } else {
       self.inviteView.hidden = NO;
   }

   if ([JPUSERINFO[@"isNewUser"] integerValue] != 0) {
        self.personalityNewView.hidden = YES;
    } else {
        self.personalityNewView.hidden = NO;
    }

   //1.
   if (self.personalityNewView.hidden == NO && self.inviteView.hidden == YES) {
       self.personalityNewViewLeftMargin.constant = -((SCR_WIDTH - 30) / 4);
   } else {
       self.personalityNewViewLeftMargin.constant = 0;

   }
}

// 团队
- (IBAction)action1:(UITapGestureRecognizer *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZMeTeamMembersController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

//我的发布
- (IBAction)action2:(UITapGestureRecognizer *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZMePublishController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

//消息通知
- (IBAction)action3:(UITapGestureRecognizer *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZSystemMessageController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

// 设置
- (IBAction)action4:(UITapGestureRecognizer *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZSettingController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

//邀请码
- (IBAction)action5:(UITapGestureRecognizer *)sender {
    CZFreeAlertView4 *alertView = [CZFreeAlertView4 freeAlertView:^(NSString * _Nonnull text) {
        if (text.length == 0) {
            [CZProgressHUD showProgressHUDWithText:@"邀请码为空"];
            // 取消菊花
            [CZProgressHUD hideAfterDelay:1.5];
            return;
        }

        NSLog(@"%@", text);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        // 要关注对象ID
        param[@"invitationCode"] = text;
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/addInvitationCode"];
        [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"code"] isEqualToNumber:@(630)]) {
                [alertView hide];
            }
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            // 取消菊花
            [CZProgressHUD hideAfterDelay:1.5];

        } failure:^(NSError *error) {
            // 取消菊花
            [CZProgressHUD hideAfterDelay:0];
        }];
    }];
    [alertView show];
}

//新人专区
- (IBAction)action6:(UITapGestureRecognizer *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    CZSubFreeChargeController *toVc = [[CZSubFreeChargeController alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

@end
