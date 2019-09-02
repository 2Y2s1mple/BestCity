//
//  CZMyWalletDetailCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletDetailCell.h"
#import "UIImageView+WebCache.h"

@interface CZMyWalletDetailCell ()
@property (nonatomic, weak) IBOutlet UIImageView *itemImg;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *preFeeLabel;
@property (nonatomic, weak) IBOutlet UILabel *statuLabel;
@end

@implementation CZMyWalletDetailCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"CZMyWalletDetailCell";
    CZMyWalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
        NSDictionary *dic = [model deleteAllNullValue];

        [self.itemImg sd_setImageWithURL:[NSURL URLWithString:dic[@"itemImg"]]];
        self.titleLabel.text = dic[@"itemTitle"];
        self.timeLabel.text = dic[@"tkPaidTime"];
        self.preFeeLabel.text = [NSString stringWithFormat:@"+¥%.2lf", [dic[@"preFee"] floatValue]];
        NSString *statuString;
        switch ([dic[@"tkStatus"] integerValue]) {
            case 3:
                statuString = @"订单结算";
                break;
            case 12:
                statuString = @"订单付款";
                break;
            case 13:
                statuString = @"订单失效";
                break;
            case 14:
                statuString = @"订单成功";
                break;

            default:
                break;
        }
        self.statuLabel.text = [NSString stringWithFormat:@"%@", statuString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
