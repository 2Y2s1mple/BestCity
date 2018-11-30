//
//  CZCommodityView.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/26.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCommodityView.h"

@interface CZCommodityView ()
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleName;
/** 券后价 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/**  其他平台价格 */
@property (nonatomic, weak) IBOutlet UILabel *otherPrice;
/** 优惠券 */
@property (nonatomic, weak) IBOutlet UILabel *couponPrice;

@end

@implementation CZCommodityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return self;
}


- (void)setModel:(CZRecommendDetailModel *)model
{
    _model = model;
    self.titleName.text = model.mainTitle;
    self.actualPriceLabel.text = [NSString stringWithFormat:@"券后价：¥%@", model.actualPrice];
    NSString *therPrice = [NSString stringWithFormat:@"%@：¥%@", model.sourcePlatform, model.sourcePlatformPrice];
    self.otherPrice.text = therPrice;
    self.couponPrice.text = [NSString stringWithFormat:@"%@元独家优惠券", model.discountCoupon];
    
    [self layoutIfNeeded];//写在这里是有问题的, 不换行还好
    self.commodityH = CGRectGetMaxY(self.bottomLabel.frame) + 10;
}
@end
