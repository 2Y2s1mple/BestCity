//
//  CZFestivalGoodsColLayoutView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/17.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalGoodsColLayoutView.h"
#import "UIImageView+WebCache.h"
#import "CZFreePushTool.h"


@interface CZFestivalGoodsColLayoutView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *backView;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;


/** 当前价格 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actualPriceLabelBottomMragin;
/** 其他价格 */
@property (nonatomic, weak) IBOutlet UILabel *otherPricelabel;
/** 券价格 */
@property (nonatomic, weak) IBOutlet UILabel *couponPriceLabel;
/** 券价格背景 */
@property (nonatomic, weak) IBOutlet UIView *couponPriceView;
/** 补贴价格 */
@property (nonatomic, weak) IBOutlet UILabel *feeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feeLabelMargin;

@end

@implementation CZFestivalGoodsColLayoutView

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
    self.titleLabel.text = dataDic[@"otherName"];


    NSString *buyBtnStr = [NSString stringWithFormat:@"¥%.0f", [dataDic[@"buyPrice"] floatValue]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:buyBtnStr];
    [attrStr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xE25838), NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size: 16]} range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size: 11]} range:NSMakeRange(0, 1)];
    self.actualPriceLabel.attributedText = attrStr;



    NSString *other = [NSString stringWithFormat:@"¥%.0lf", [dataDic[@"otherPrice"] floatValue]];
    self.otherPricelabel.attributedText = [other addStrikethroughWithRange:NSMakeRange(0, other.length)];


    self.couponPriceLabel.text = [NSString stringWithFormat:@"券%.0f", [dataDic[@"couponPrice"] floatValue]];

    self.feeLabel.text = [NSString stringWithFormat:@"  补%.2f  ", [dataDic[@"fee"] floatValue]];

    if ([self.couponPriceLabel.text isEqualToString:@"券0"]) {
        self.couponPriceView.hidden = YES;
        self.feeLabelMargin.constant = -38;
        [self layoutIfNeeded];
    } else {
        self.couponPriceView.hidden = NO;
        self.feeLabelMargin.constant = 5;
    }

    if ([self.feeLabel.text isEqualToString:@"  补贴0.00  "]) {
        [self.feeLabel setHidden:YES];
    } else {
        [self.feeLabel setHidden:NO];
    }

    if ([self.couponPriceLabel.text isEqualToString:@"券0"] && [self.feeLabel.text isEqualToString:@"  补0.00  "]) {
        [self.feeLabel setHidden:YES];
        self.couponPriceView.hidden = YES;
        self.actualPriceLabelBottomMragin.constant = -21;
    } else {
        [self.feeLabel setHidden:NO];
        self.actualPriceLabelBottomMragin.constant = 8;
    }

}


@end
