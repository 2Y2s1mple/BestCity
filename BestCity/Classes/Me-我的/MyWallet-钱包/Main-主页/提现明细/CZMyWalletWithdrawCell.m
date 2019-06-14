//
//  CZMyWalletWithdrawCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletWithdrawCell.h"

@interface CZMyWalletWithdrawCell ()
/** line */
@property (nonatomic, weak) IBOutlet UIView *lineView;
/** 钱 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 时间 */
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
/** 状态 */
@property (nonatomic, weak) IBOutlet UILabel *statuLabel;
/** 原因 */
@property (nonatomic, weak) IBOutlet UILabel *seasonLabel;


@end

@implementation CZMyWalletWithdrawCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"CZMyWalletWithdrawCell";
    CZMyWalletWithdrawCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(CZWithdrawModel *)model
{
    _model = model;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf", [model.amount floatValue]];
    self.priceLabel.textColor = CZREDCOLOR;
    self.timeLabel.text = model.createTime;
    NSString *statuString;
    switch ([model.status integerValue]) {
        case -1:
            statuString = @"提现失败";
            break;
        case 0:
            statuString = @"审核中";
            break;
        case 1:
            statuString = @"提现成功";
            self.priceLabel.textColor = UIColorFromRGB(0x0F9D55);
            break;

        default:
            break;
    }
    self.statuLabel.text = statuString;
    self.seasonLabel.text = model.failReason;

    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.lineView);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.seasonLabel.backgroundColor = [UIColor greenColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
