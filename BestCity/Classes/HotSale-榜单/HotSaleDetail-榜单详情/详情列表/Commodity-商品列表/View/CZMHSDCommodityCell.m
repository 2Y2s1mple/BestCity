//
//  CZMHSDCommodityCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDCommodityCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface CZMHSDCommodityCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** topx */
@property (nonatomic, weak) IBOutlet UILabel *topNumberLabel;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** tag1 */
@property (nonatomic, weak) IBOutlet UIButton *tag1;
/** tag2 */
@property (nonatomic, weak) IBOutlet UIButton *tag2;
/** tag3 */
@property (nonatomic, weak) IBOutlet UIButton *tag3;
/** tag4 */
@property (nonatomic, weak) IBOutlet UIButton *tag4;
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

@implementation CZMHSDCommodityCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZMHSDCommodityCell";
    CZMHSDCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
    self.titleLabel.text = dataDic[@"goodsName"];
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    self.tag4.hidden = YES;

    CGFloat maxWidth = SCR_WIDTH;

    NSArray *tagsArr = dataDic[@"goodsTagsList"];
    for (int i = 0; i < tagsArr.count; i++) {
        switch (i) {
            case 0:
                [self.tag1 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                self.tag1.hidden = NO;
                self.tag2.hidden = YES;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                break;
            case 1:
                [self.tag2 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                [self layoutIfNeeded];
                if (CGRectGetMaxX(self.tag2.frame) > SCR_WIDTH) {
                    break;
                }
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                break;
            case 2:
                [self.tag3 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
                [self layoutIfNeeded];
                if (CGRectGetMaxX(self.tag3.frame) > SCR_WIDTH) {
                    break;
                }
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = YES;
                break;
            case 3:
//                [self.tag4 setTitle:tagsArr[i][@"name"] forState:UIControlStateNormal];
//                self.tag1.hidden = NO;
//                self.tag2.hidden = NO;
//                self.tag3.hidden = NO;
//                self.tag4.hidden = NO;
                break;
            default:
                break;
        }
    }
    NSDictionary *paramDic = dataDic;
    self.actualPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [paramDic[@"buyPrice"] floatValue]];
    NSString *other = [NSString stringWithFormat:@"¥%.2f", [paramDic[@"otherPrice"] floatValue]];
    self.otherPricelabel.attributedText = [other addStrikethroughWithRange:NSMakeRange(0, other.length)];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"优惠券 ¥%.0f", [paramDic[@"couponPrice"] floatValue]];
    self.feeLabel.text = [NSString stringWithFormat:@"  补贴 ¥%.2f  ", [paramDic[@"fee"] floatValue]];

    if ([self.couponPriceLabel.text isEqualToString:@"优惠券 ¥0"]) {
        [[self.couponPriceLabel superview] setHidden:YES];
        self.feeLabelMargin.constant = -75;
        [self layoutIfNeeded];
    }

    if ([self.feeLabel.text isEqualToString:@"  补贴 ¥0.00  "]) {
        [self.feeLabel setHidden:YES];
    }

    if ([self.couponPriceLabel.text isEqualToString:@"优惠券 ¥0"] && [self.feeLabel.text isEqualToString:@"  补贴 ¥0.00  "]) {
        self.actualPriceLabelBottomMragin.constant = -18;
    }

}

- (void)setIndexNumber:(NSInteger)indexNumber
{
    _indexNumber = indexNumber;
    self.topNumberLabel.text = [NSString stringWithFormat:@"TOP%ld", (self.indexNumber + 1)];
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

@end
