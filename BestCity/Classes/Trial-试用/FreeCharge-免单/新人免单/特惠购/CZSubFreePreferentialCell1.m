//
//  CZSubFreePreferentialCell1.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/6.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSubFreePreferentialCell1.h"
#import "CZSubFreeMyAllowanceList.h" // 津贴使用记录


@interface CZSubFreePreferentialCell1 ()
/** 我的津贴 */
@property (nonatomic, weak) IBOutlet UILabel *allowanceLabel;
/** 一共节省了 */
@property (nonatomic, weak) IBOutlet UILabel *totalUsedAllowanceLabel;
/** 津贴 */
@property (nonatomic, weak) IBOutlet UIButton *AllowanceListBtn;
@end

@implementation CZSubFreePreferentialCell1

- (void)setModel:(CZSubFreeChargeModel *)model
{
    _model = model;
    self.allowanceLabel.text = [NSString stringWithFormat:@"%@", model.allowance];
    self.totalUsedAllowanceLabel.text = [NSString stringWithFormat:@"%@", model.totalUsedAllowance];
    _model.cellHeight = 276;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZSubFreePreferentialCell1";
    CZSubFreePreferentialCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)freeDescAction:(id)sender {

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/new-free-desc.html"]];
    webVc.titleName = @"规则说明";
    [currentVc presentViewController:webVc animated:YES completion:nil];
}

/** 跳转津贴使用记录 */
- (IBAction)pushAllowanceList
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    CZSubFreeMyAllowanceList *vc = [[CZSubFreeMyAllowanceList alloc] init];
    [currentVc.navigationController pushViewController:vc animated:YES];
}

 - (IBAction)pushPointsController
{
    // 跳商城
    UIViewController *toVc = [[NSClassFromString(@"CZMyPointsController") alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    [currentVc.navigationController pushViewController:toVc animated:YES];
}


@end
