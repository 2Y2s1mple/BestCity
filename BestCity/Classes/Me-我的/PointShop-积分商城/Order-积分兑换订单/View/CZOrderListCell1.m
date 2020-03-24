//
//  CZOrderListCell1.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/10.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZOrderListCell1.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
#import "CZOrderController.h"

@interface CZOrderListCell1 ()
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *affirmBtn;
/** 实付 */
@property (nonatomic, weak) IBOutlet UILabel *realPayLabel;
/** 状态 */
@property (nonatomic, weak) IBOutlet UILabel *statuslabel;
/** 名字 */
@property (nonatomic, weak) IBOutlet UILabel *goodsName;
/** 实付 */
@property (nonatomic, weak) IBOutlet UILabel *pointLabel;
/** 发货时间 */
@property (nonatomic, weak) IBOutlet UILabel *sendTimelabel;
/** 总数 */
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 下划线 */
@property (nonatomic, weak) IBOutlet UIView *lineView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *remarkLabel;
@end

@implementation CZOrderListCell1

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"CZOrderListCell1";
    CZOrderListCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.realPayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
//    self.affirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 5;
    frame.origin.x = 5;
    frame.size.width -= 10;
    return [super setFrame:frame];
}

- (void)setModel:(CZOrderModel *)model
{
    _model = model;

    switch ([model.goodsType integerValue]) {
        case 1:
            self.titleLabel.text = @"免费试用";
            break;
        case 2:
            self.titleLabel.text = @"积分商城";
            break;
        case 21:
            self.titleLabel.text = @"积分商城会员卡";
            break;
        case 22:
            self.titleLabel.text = @"积分商城津贴";
            break;
        case 3:
            self.titleLabel.text = @"免单";
            break;
        default:
            break;
    }


    NSString *statuslabel;
    switch ([model.status integerValue]) {
        case 2:
            statuslabel = @"待收货";
            self.sendTimelabel.text = [NSString stringWithFormat:@"发件时间：%@", model.sendTime];
            break;
        case 1:
            statuslabel = @"待发货";
            self.sendTimelabel.text = [NSString stringWithFormat:@"下单时间：%@", model.payTime];
            break;
        case 3:
            statuslabel = @"已完成";
            self.sendTimelabel.text = [NSString stringWithFormat:@"收件时间：%@", model.finishTime];
            break;
        default:
            break;
    }

    self.statuslabel.text = statuslabel;
    self.goodsName.text = model.goodsName;
    self.pointLabel.text = [NSString stringWithFormat:@"实付:%@极币", model.point];
    self.totalLabel.text = [NSString stringWithFormat:@"x%@", model.total];
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.remarkLabel.text = model.remark;

    self.model.heightCell = CZGetY(self.affirmBtn) + 20;

}

/** affirm */
- (IBAction)affirmAction:(UIButton *)sender
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = self.model.remark;
    [CZProgressHUD showProgressHUDWithText:@"复制成功"];
    [CZProgressHUD hideAfterDelay:1.5];
    [recordSearchTextArray addObject:posteboard.string];
}

- (void)uploadTableView
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZOrderController *vc = nav.topViewController;
    [vc getDataSource];
}

@end
