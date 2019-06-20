//
//  CZCZFreeChargeCell2.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCZFreeChargeCell2.h"
@interface CZCZFreeChargeCell2 ()
/** 背景视图View */
@property (nonatomic, weak) IBOutlet UIView *bigView;
/** 图片的View */
@property (nonatomic, weak) IBOutlet UIView *backView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 极币数 */
@property (nonatomic, weak) IBOutlet UILabel *jibiLabel;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;

/** 一共 */
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
/** 剩余 */
@property (nonatomic, weak) IBOutlet UILabel *residueLabel;

@end

@implementation CZCZFreeChargeCell2
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZCZFreeChargeCell2";
    CZCZFreeChargeCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(CZFreeChargeModel *)model
{
    _model = model;
    self.titleLabel.text = @"哈哈哈哈哈哎假假按揭";

    // 红条
    self.totalLabel.text = @""; 
    self.residueLabel.text = @"";

    self.jibiLabel.text = [NSString stringWithFormat:@"%@极币", @"1200"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", @"29.03"];
    self.oldPriceLabel.attributedText = [@"¥2198.00" addStrikethroughWithRange:[@"¥2198.00" rangeOfString:[NSString stringWithFormat:@"¥%@", @"2198.00"]]];

    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.bigView);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.totalLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
    self.residueLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];


    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.jibiLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];

    // 设置圆角
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    self.bigView.layer.cornerRadius = 5;
    self.bigView.layer.shadowColor = UIColorFromRGB(0x828282).CGColor;
    self.bigView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bigView.layer.shadowOpacity = 1;
    self.bigView.layer.shadowRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
