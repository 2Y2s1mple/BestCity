//
//  CZMyWalletCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletCell.h"
#import "UIImageView+WebCache.h"

@interface  CZMyWalletCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopConst;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *yearLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *itemImg;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *preFeeLabel;
@property (nonatomic, weak) IBOutlet UILabel *statuLabel;

/** 第二个背景图 */
@property (nonatomic, weak) IBOutlet UIView *backView1;
@property (nonatomic, weak) IBOutlet UIImageView *itemImg1;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel1;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel1;
@property (nonatomic, weak) IBOutlet UILabel *preFeeLabel1;
@property (nonatomic, weak) IBOutlet UILabel *statuLabel1;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *btn;

@end


@implementation CZMyWalletCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"CZMyWalletCell";
    CZMyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.yearLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    
    self.mainView.layer.cornerRadius = 5;
    self.mainView.layer.shadowColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1.0].CGColor;
    self.mainView.layer.shadowOffset = CGSizeMake(0,0);
    self.mainView.layer.shadowOpacity = 0.3;
    self.mainView.layer.shadowRadius = 5;
}

- (void)setModel:(CZMyWalletModel *)model
{
    _model = model;
    NSArray *array = model.commissionDetailList;
    if (array.count == 1) {
        NSDictionary *dic = array[0];
        self.yearLabel.text = [NSString stringWithFormat:@"%@-%@", model.year, model.month];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf", [model.totalPreFee floatValue]];
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
        self.backView1.hidden = YES;
        self.btnTopConst.constant = 17 - 105;
        [self layoutIfNeeded];
        model.cellHeight = CZGetY(self.mainView) + 8;

    } else if (array.count >= 2) {
        NSDictionary *dic = array[0];
        self.yearLabel.text = [NSString stringWithFormat:@"%@-%@", model.year, model.month];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf", [model.totalPreFee floatValue]];

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

        NSDictionary *dic1 = array[1];
        switch ([dic1[@"tkStatus"] integerValue]) {
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
        [self.itemImg1 sd_setImageWithURL:[NSURL URLWithString:dic1[@"itemImg"]]];
        self.titleLabel1.text = dic1[@"itemTitle"];
        self.timeLabel1.text = dic1[@"tkPaidTime"];
        self.preFeeLabel1.text = [NSString stringWithFormat:@"+¥%.2lf", [dic[@"preFee"] floatValue]];

        self.statuLabel1.text = [NSString stringWithFormat:@"%@", statuString];
        [self layoutIfNeeded];
        model.cellHeight = CZGetY(self.mainView) + 8;
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
