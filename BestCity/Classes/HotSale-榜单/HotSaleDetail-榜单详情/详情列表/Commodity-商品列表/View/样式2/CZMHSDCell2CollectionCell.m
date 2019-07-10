//
//  CZMHSDCell2CollectionCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDCell2CollectionCell.h"
#import "UIImageView+WebCache.h"

@interface CZMHSDCell2CollectionCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 价格 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/** topx */
@property (nonatomic, weak) IBOutlet UILabel *topNumberLabel;
@end

@implementation CZMHSDCell2CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topNumberLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 20];

}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
    self.titleLabel.text = dataDic[@"goodsName"];
    NSString *actualPrice = [NSString stringWithFormat:@"¥%.2f", [dataDic[@"actualPrice"] floatValue]];
    self.actualPriceLabel.text = actualPrice;
}

- (void)setIndexNumber:(NSInteger)indexNumber
{
    _indexNumber = indexNumber;
    self.topNumberLabel.text = [NSString stringWithFormat:@"%ld", (self.indexNumber + 1)];
}

@end
