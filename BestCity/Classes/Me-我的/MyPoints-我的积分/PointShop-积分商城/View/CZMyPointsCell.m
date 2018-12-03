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
/** 钱数 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 去兑换 */
@property (nonatomic, weak) IBOutlet UIButton *bugButton;
@end

@implementation CZMyPointsCell
- (IBAction)buyButtonAction:(id)sender {
    [CZProgressHUD showProgressHUDWithText:@"积分不足!"];
    [CZProgressHUD hideAfterDelay:1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bugButton.layer.borderWidth = 1;
    self.bugButton.layer.borderColor = CZREDCOLOR.CGColor;
    self.bugButton.layer.cornerRadius = 3.5;
    self.bugButton.layer.masksToBounds = YES;
}

- (void)setDicData:(NSDictionary *)dicData
{
    _dicData = dicData;
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:dicData[@"rankGoodImg"]] placeholderImage:[UIImage imageNamed:@"testImage6"]];
    self.titleLabel.text = dicData[@"goodsName"];
    self.pointLabel.text = [NSString stringWithFormat:@"%@积分", dicData[@"goodsPoint"]];
    NSString *otherPrice = [NSString stringWithFormat:@"¥%0.2f", [dicData[@"otherPrice"] floatValue]];
    self.priceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
}

@end
