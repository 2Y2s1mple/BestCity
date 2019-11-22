//
//  CZMeCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMeCell.h"
#import "CZMeController.h"
#import "CZOrderController.h"

#import "CZInvitationController.h"
#import "CZOrderController.h"
#import "CZAllOrderController.h" // 我的全部订单

#import "CZMyWalletController.h"
#import "CZMyPointsController.h"
#import "CZMyTrialController.h" // 试用
#import "CZMePublishController.h" // 发布

@interface CZMeCell ()
/** 邀请 */
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
/** 试用 */
@property (weak, nonatomic) IBOutlet UILabel *tryOutlabel;
/** 发布 */
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
/** 钱包 */
@property (weak, nonatomic) IBOutlet UILabel *walletLabel;

@end

@implementation CZMeCell

- (IBAction)signInAction:(UITapGestureRecognizer *)sender {
    // 任务中心
    NSString *text = @"我的--邀请领奖";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    // 任务中心
     UIViewController *toVc = [[NSClassFromString(@"CZCoinCenterController") alloc] init];
       [vc.navigationController pushViewController:toVc animated:YES];
}

- (IBAction)coinAction:(UITapGestureRecognizer *)sender {
    // 跳我的免单
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZFreeOrderController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

- (IBAction)orderAction:(UITapGestureRecognizer *)sender {
    // 跳全部订单
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    UIViewController *toVc = [[NSClassFromString(@"CZAllOrderController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

- (IBAction)walletAction:(UITapGestureRecognizer *)sender {
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    // 跳商城
    UIViewController *toVc = [[NSClassFromString(@"CZMyPointsController") alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"meCell";
    CZMeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZMeCell class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
}

- (void)setupMoney:(NSDictionary *)result
{
    // 总金额
    NSString *total = [self changeStr:result[@"total_account"] ? result[@"total_account"] : @""];
    // 已体现
    NSString *afterAccount = [self changeStr:result[@"use_account"]];
}

- (NSString *)changeStr:(id)value
{
    return [NSString stringWithFormat:@"%0.2f", [value floatValue]];
}

@end
