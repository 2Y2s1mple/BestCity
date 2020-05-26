//
//  CZSub2FreeChargeCell.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/25.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSub2FreeChargeCell.h"
#import "UIImageView+WebCache.h"

@interface CZSub2FreeChargeCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/** 原价格 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;

/** 券价格 */
@property (nonatomic, weak) IBOutlet UIButton *couponPriceBtn;
/**  */
@property (nonatomic, weak) IBOutlet UIButton *feeBtn;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *maskView;
@end

@implementation CZSub2FreeChargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    NSInteger count = [dataDic[@"total"] integerValue];
    if (count == 0) {
        self.maskView.hidden = NO;
    } else {
        self.maskView.hidden = YES;
    }
    
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]]];
    self.titleLabel.text = dataDic[@"otherName"];
    
    NSString *other = [NSString stringWithFormat:@"原价:%.2lf", [dataDic[@"otherPrice"] floatValue]];
    self.actualPriceLabel.attributedText = [other addStrikethroughWithRange:NSMakeRange(0, other.length)];

    
    [self.couponPriceBtn setTitle:[NSString stringWithFormat:@"券￥%.0f", [dataDic[@"couponPrice"] floatValue]] forState:UIControlStateNormal];
    
    
     NSString *buyBtnStr = [NSString stringWithFormat:@"付￥%.2f，返￥%.2f", [dataDic[@"actualPrice"] floatValue], [dataDic[@"fee"] floatValue]];
    [self.feeBtn setTitle:buyBtnStr forState:UIControlStateNormal];
    
   
    [NSDate date];
}

@end
