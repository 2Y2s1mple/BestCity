//
//  CZEvaluationBottomView.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEvaluationBottomView.h"
#import "Masonry.h"

@interface CZEvaluationBottomView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *actualPricelabel;

@property (nonatomic, weak) IBOutlet UILabel *otherPricelabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *couponPriceLabel;
/**  */
@property (nonatomic, weak) IBOutlet UILabel *feeLabel;

@end

@implementation CZEvaluationBottomView

+ (instancetype)evaluationBottomView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.layer.shadowColor = [UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,-2.5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 6.5;
}

- (void)setParamDic:(NSDictionary *)paramDic
{
    _paramDic = paramDic;
    self.actualPricelabel.text = [NSString stringWithFormat:@"¥%.2f", [paramDic[@"actualPrice"] floatValue]];
    NSString *other = [NSString stringWithFormat:@"¥%.2f", [paramDic[@"otherPrice"] floatValue]];
    self.otherPricelabel.attributedText = [other addStrikethroughWithRange:NSMakeRange(0, other.length)];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"优惠券 ¥%.0f", [paramDic[@"couponPrice"] floatValue]];
    self.feeLabel.text = [NSString stringWithFormat:@"  补贴 ¥%.2f  ", [paramDic[@"fee"] floatValue]];

    if ([self.couponPriceLabel.text isEqualToString:@"优惠券 ¥0"]) {
        [[self.couponPriceLabel superview] setHidden:YES];
        [self.feeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(15));
        }];
    }

    if ([self.feeLabel.text isEqualToString:@"  补贴 ¥0.00  "]) {
        [self.feeLabel setHidden:YES];
    }

}

/** 立即购买 */
- (IBAction)bugAction
{
    NSLog(@"-----");
    !self.bugBlock ? : self.bugBlock();
}

@end
