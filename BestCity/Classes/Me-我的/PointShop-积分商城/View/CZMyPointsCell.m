//
//  CZMyPointsCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMyPointsCell.h"
#import "UIImageView+WebCache.h"

@interface CZMyPointsCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 积分数 */
@property (nonatomic, weak) IBOutlet UILabel *pointLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *smallImage;

@end

@implementation CZMyPointsCell
- (IBAction)buyButtonAction:(id)sender {
    [CZProgressHUD showProgressHUDWithText:@"积分不足!"];
    [CZProgressHUD hideAfterDelay:1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pointLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
}

- (void)setDicData:(NSDictionary *)dicData
{
    _dicData = dicData;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:dicData[@"img"]] placeholderImage:[UIImage imageNamed:@"testImage6"]];
    self.titleLabel.text = dicData[@"goodsName"];
    self.pointLabel.text = [NSString stringWithFormat:@"%@极币", dicData[@"exchangePoint"]];
    // 0普通商品，1限购一次
    if ([dicData[@"type"]  isEqual: @(1)]) {
        self.smallImage.hidden = YES;
    } else {
        self.smallImage.hidden = NO;
    }
    
//    NSString *otherPrice = [NSString stringWithFormat:@"¥%0.2f", [dicData[@"otherPrice"] floatValue]];
//    self.priceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
}

@end
