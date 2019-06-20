//
//  CZFreeChargeCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell.h"
@interface CZFreeChargeCell ()
/** 背景视图View */
@property (nonatomic, weak) IBOutlet UIView *bigView;
/** 图片的View */
@property (nonatomic, weak) IBOutlet UIView *backView;
/** 极币数 */
@property (nonatomic, weak) IBOutlet UILabel *jibiLabel;
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

- (void)setModel:(CZFreeChargeModel *)model
{
    _model = model;
    self.jibiLabel.text = [NSString stringWithFormat:@"%@极币", @"50"];

    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.bigView);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.jibiLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];

    // 设置阴影
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
