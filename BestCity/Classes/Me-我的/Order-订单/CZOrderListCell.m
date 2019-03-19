//
//  CZOrderListCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZOrderListCell.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
#import "CZOrderController.h"


@interface CZOrderListCell ()
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

@end

@implementation CZOrderListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"orderListCell";
    CZOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
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
    self.sendTimelabel.hidden = NO;
    self.sendTimelabel.text = [NSString stringWithFormat:@"发件时间：%@", model.sendTime];
    
    NSString *statuslabel;
    switch ([model.status integerValue]) {
        case 2:
            statuslabel = @"待收货";
            break;
        case 1:
            statuslabel = @"待发货";
            self.sendTimelabel.hidden = YES;
            break;
        case 3:
            statuslabel = @"已完成";
            self.sendTimelabel.text = [NSString stringWithFormat:@"发件时间：%@", model.finishTime];
            break;
        default:
            break;
    }
    
    self.statuslabel.text = statuslabel;
    self.goodsName.text = model.goodsName;
    self.pointLabel.text = [NSString stringWithFormat:@"实付:%@极币", model.point];
    self.totalLabel.text = [NSString stringWithFormat:@"x%@", model.total];
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    
    [self layoutIfNeeded];
    if ([statuslabel  isEqual: @"待收货"]) {
        self.model.heightCell = CZGetY(self.affirmBtn) + 20;
    } else {
        self.model.heightCell = self.lineView.y;
    }
}

/** affirm */
- (IBAction)affirmAction:(UIButton *)sender
{
    sender.enabled = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.model.orderId;
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/order/confirm"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
            [CZProgressHUD showProgressHUDWithText:@"商品兑换成功"];
            [CZProgressHUD hideAfterDelay:1.5];
            [self uploadTableView];
        } 
        sender.enabled = YES;
    } failure:^(NSError *error) {
        sender.enabled = YES;
    }];
}

- (void)uploadTableView
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZOrderController *vc = nav.topViewController;
    [vc getDataSource];
}

@end
