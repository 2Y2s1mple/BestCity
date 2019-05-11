//
//  CZMeCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMeCell.h"

#import "CZMeController.h"
#import "CZInvitationController.h"
#import "CZOrderController.h"
#import "CZMyWalletController.h"
#import "CZMyPointsController.h"

@interface CZMeCell ()
/** 总钱数 */
@property (weak, nonatomic) IBOutlet UIView *signInView;
/** 处理中 */
@property (weak, nonatomic) IBOutlet UIView *coinView;
/** 可提现 */
@property (weak, nonatomic) IBOutlet UIView *orderView;
/** 待结算 */
@property (weak, nonatomic) IBOutlet UIView *walletView;

@end

@implementation CZMeCell

- (IBAction)signInAction:(UITapGestureRecognizer *)sender {
    NSString *text = @"我的--邀请领奖";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    // 跳邀请
    CZInvitationController *toVc = [[CZInvitationController alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}
- (IBAction)coinAction:(UITapGestureRecognizer *)sender {
    NSString *text = @"我的--极币商城";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    // 跳商城
    CZMyPointsController *toVc = [[CZMyPointsController alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}
- (IBAction)orderAction:(UITapGestureRecognizer *)sender {
    NSString *text = @"我的--我的订单";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    // 跳订单
    CZOrderController *toVc = [[CZOrderController alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}
- (IBAction)walletAction:(UITapGestureRecognizer *)sender {
    NSString *text = @"我的--我的钱包";
    NSDictionary *context = @{@"mine" : text};
    [MobClick event:@"ID5" attributes:context];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZMeController *vc = (CZMeController *)nav.topViewController;
    // 跳钱包
    CZMyWalletController *toVc = [[CZMyWalletController alloc] init];
    [vc.navigationController pushViewController:toVc animated:YES];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
