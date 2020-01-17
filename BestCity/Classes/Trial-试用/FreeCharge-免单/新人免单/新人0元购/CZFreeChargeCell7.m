//
//  CZFreeChargeCell7.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/3.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell7.h"
#import "UIImageView+WebCache.h"
#import "CZSubFreePreferentialController.h"

@interface CZFreeChargeCell7 ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;
/** 优惠券 */
@property (nonatomic, weak) IBOutlet UILabel *couponsLabel;
/** 津贴 */
@property (nonatomic, weak) IBOutlet UILabel *allowanceLabel;
/** 立即抢购 */
@property (nonatomic, weak) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allowanceLabelLeftMargin;

@end

@implementation CZFreeChargeCell7

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeChargeCell7";
    CZFreeChargeCell7 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(CZSubFreeChargeModel *)model
{
    _model = model;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    self.titleLabel.text = _model.goodsName;

    self.couponsLabel.text = [NSString stringWithFormat:@"券 ¥%@", _model.couponPrice];

    self.allowanceLabel.text = [NSString stringWithFormat:@"津贴 ¥%@", _model.useAllowancePrice];
    if ([self.couponsLabel.text isEqualToString:@"券 ¥0"]) {
        self.allowanceLabelLeftMargin.constant = -45;
    } else {
        self.allowanceLabelLeftMargin.constant = 3;
    }

    NSString *otherPrice = [NSString stringWithFormat:@"淘宝价¥%.2f", [_model.otherPrice floatValue]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];

    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", _model.buyPrice];

    _model.cellHeight = 140;
}

- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.origin.x = 10;
    rect.size.width -= 20;

    rect.origin.y += 5;
    rect.size.height -= 10;
    [super setFrame:rect];
}

- (IBAction)bugBtnClicked:(UIButton *)sender {
    NSLog(@"----");
    [CZJIPINSynthesisTool buyBtnActionWithId:self.model.Id alertTitle:@"您将前往淘宝购买此商品，下单立减"];
}
@end
