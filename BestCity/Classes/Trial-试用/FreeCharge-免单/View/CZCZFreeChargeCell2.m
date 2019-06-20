//
//  CZCZFreeChargeCell2.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCZFreeChargeCell2.h"
#import "UIImageView+WebCache.h"

@interface CZCZFreeChargeCell2 ()
/** 背景视图View */
@property (nonatomic, weak) IBOutlet UIView *bigView;
/** 图片的View */
@property (nonatomic, weak) IBOutlet UIView *backView;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 极币数 */
@property (nonatomic, weak) IBOutlet UILabel *jibiLabel;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;

/** lineView */
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jibiTopMargin;
@property (nonatomic, weak) IBOutlet UIView *goryBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewWidth;


/** 即将开启 */
@property (nonatomic, weak) IBOutlet UIButton *btn;
/** 一共 */
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
/** 剩余 */
@property (nonatomic, weak) IBOutlet UILabel *residueLabel;

@end

@implementation CZCZFreeChargeCell2
- (void)setModel:(CZFreeChargeModel *)model
{
    _model = model;

    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.titleLabel.text = model.name;
    self.jibiLabel.text = [NSString stringWithFormat:@"%@极币", model.point];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf", [model.actualPrice floatValue]];
    NSString *otherPrice = [NSString stringWithFormat:@"¥%.2lf", [model.otherPrice floatValue]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];

    // 条
    self.lineView.hidden = NO;
    self.jibiTopMargin.constant = 28;


    switch ([model.status integerValue]) {// （0即将开始，1进行中，2已结束）
        case 0:
            [self.btn setTitle:@"即将开始" forState:UIControlStateNormal];
            [self.btn setBackgroundColor:[UIColor whiteColor]];
            [self.btn setTitleColor:UIColorFromRGB(0xF76B1C) forState:UIControlStateNormal];
            self.btn.layer.borderColor = UIColorFromRGB(0xF76B1C).CGColor;
            self.lineView.hidden = YES;
            self.jibiTopMargin.constant = -30;
            break;
        case 1:
        {
            [self.btn setTitle:@"立即抢购" forState:UIControlStateNormal];
            [self.btn setBackgroundColor:UIColorFromRGB(0xE31B3C)];
            [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.btn.layer.borderColor = UIColorFromRGB(0xE31B3C).CGColor;
            self.totalLabel.text = [NSString stringWithFormat:@"共%@件", model.count];
            NSString *residueStr = [NSString stringWithFormat:@"已抢%@件", model.userCount];
            self.residueLabel.attributedText = [residueStr addAttributeColor:CZREDCOLOR Range:[residueStr rangeOfString:model.userCount]];
            // residueLabel  xxx
            // totalLabel goryBackView.width
            [self layoutIfNeeded];

            CGFloat scale = [model.userCount floatValue] / [model.count floatValue];

            self.redViewWidth.constant = scale * (SCR_WIDTH - 44 - 28);

            break;
        }
        case 2:
        {
            [self.btn setTitle:@"已售罄" forState:UIControlStateNormal];
            [self.btn setBackgroundColor:UIColorFromRGB(0xACACAC)];
            [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.btn.layer.borderColor = UIColorFromRGB(0xACACAC).CGColor;
            self.totalLabel.text = [NSString stringWithFormat:@"共%@件", model.count];
            NSString *residueStr = [NSString stringWithFormat:@"已抢%@件", model.userCount];
            self.residueLabel.attributedText = [residueStr addAttributeColor:CZREDCOLOR Range:[residueStr rangeOfString:model.userCount]];
            [self layoutIfNeeded];
            CGFloat scale = [model.userCount floatValue] / [model.count floatValue];

            self.redViewWidth.constant = scale * (SCR_WIDTH - 44 - 28);
            break;
        }

        default:
            break;
    }


    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.bigView);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZCZFreeChargeCell2";
    CZCZFreeChargeCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
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
