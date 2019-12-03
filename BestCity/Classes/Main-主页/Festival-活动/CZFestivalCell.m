//
//  CZFestivalCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCell.h"
#import "UIImageView+WebCache.h"

@interface CZFestivalCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;

/** 当前价格 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actualPriceLabelBottomMragin;
@property (nonatomic, weak) IBOutlet UILabel *otherPricelabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *couponPriceLabel;
/**  */
@property (nonatomic, weak) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feeLabelMargin;
@end

@implementation CZFestivalCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFestivalCell";
    CZFestivalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.actualPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"goods"][@"img"]]];
    self.titleLabel.text = dataDic[@"goods"][@"goodsName"];


    NSArray *tagsArr = dataDic[@"goods"][@"goodsTagsList"];
    NSMutableString *mutStr = [NSMutableString string];
    for (int i = 0; i < tagsArr.count; i++) {
        if (i == 0) {
            [mutStr appendFormat:@"%@", tagsArr[i][@"name"]];
        } else {
            [mutStr appendFormat:@"、%@", tagsArr[i][@"name"]];
        }
    }

    self.subTitleLabel.text = mutStr;

    NSDictionary *paramDic = dataDic[@"goods"];
    self.actualPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [paramDic[@"buyPrice"] floatValue]];
    NSString *other = [NSString stringWithFormat:@"¥%@", paramDic[@"otherPrice"]];
    self.otherPricelabel.attributedText = [other addStrikethroughWithRange:NSMakeRange(0, other.length)];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"优惠券 ¥%.0f", [paramDic[@"couponPrice"] floatValue]];
    self.feeLabel.text = [NSString stringWithFormat:@"  补贴 ¥%.2f  ", [paramDic[@"fee"] floatValue]];

    if ([self.couponPriceLabel.text isEqualToString:@"优惠券 ¥0"]) {
        [[self.couponPriceLabel superview] setHidden:YES];
        self.feeLabelMargin.constant = -75;
        [self layoutIfNeeded];
    } else {
        [[self.couponPriceLabel superview] setHidden:NO];
        self.feeLabelMargin.constant = 5;
    }

    if ([self.feeLabel.text isEqualToString:@"  补贴 ¥0.00  "]) {
        [self.feeLabel setHidden:YES];
    } else {
        [self.feeLabel setHidden:NO];
    }

    if ([self.couponPriceLabel.text isEqualToString:@"优惠券 ¥0"] && [self.feeLabel.text isEqualToString:@"  补贴 ¥0.00  "]) {
        self.actualPriceLabelBottomMragin.constant = -18;
    } else {
        self.actualPriceLabelBottomMragin.constant = 5;
    }

}

- (void)setDataDic1:(NSDictionary *)dataDic1
{
    _dataDic1 = dataDic1;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic1[@"img"]]];
    self.titleLabel.text = dataDic1[@"goodsName"];

    

    NSArray *tagsArr = dataDic1[@"goodsTagsList"];
    NSMutableString *mutStr = [NSMutableString string];
    for (int i = 0; i < tagsArr.count; i++) {
        if (i == 0) {
            [mutStr appendFormat:@"%@", tagsArr[i][@"name"]];
        } else {
            [mutStr appendFormat:@"、%@", tagsArr[i][@"name"]];
        }
    }

    self.subTitleLabel.text = mutStr;

    NSDictionary *paramDic = dataDic1;
    self.actualPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [paramDic[@"buyPrice"] floatValue]];
    NSString *other = [NSString stringWithFormat:@"¥%.2f", [paramDic[@"otherPrice"] floatValue]];
    self.otherPricelabel.attributedText = [other addStrikethroughWithRange:NSMakeRange(0, other.length)];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"优惠券 ¥%.0f", [paramDic[@"couponPrice"] floatValue]];
    self.feeLabel.text = [NSString stringWithFormat:@"  补贴 ¥%.2f  ", [paramDic[@"fee"] floatValue]];

    if ([self.couponPriceLabel.text isEqualToString:@"优惠券 ¥0"]) {
        [[self.couponPriceLabel superview] setHidden:YES];
        self.feeLabelMargin.constant = -75;
        [self layoutIfNeeded];
    } else {
        [[self.couponPriceLabel superview] setHidden:NO];
        self.feeLabelMargin.constant = 5;
        [self layoutIfNeeded];
    }

    if ([self.feeLabel.text isEqualToString:@"  补贴 ¥0.00  "]) {
        [self.feeLabel setHidden:YES];
    } else {
        [self.feeLabel setHidden:NO];
    }

    if ([self.couponPriceLabel.text isEqualToString:@"优惠券 ¥0"] && [self.feeLabel.text isEqualToString:@"  补贴 ¥0.00  "]) {
        self.actualPriceLabelBottomMragin.constant = -18;
    } else {
        self.actualPriceLabelBottomMragin.constant = 5;
    }

}



@end
