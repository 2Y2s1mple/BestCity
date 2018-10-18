//
//  CZHotSaleCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotSaleCell.h"
#import "NSString+CZExtension.h"

@interface CZHotSaleCell ()
@property (weak, nonatomic) IBOutlet UILabel *tmPrice;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNumber;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//推荐理由
@property (weak, nonatomic) IBOutlet UILabel *recommendReasonLabel;
//综合评分
@property (weak, nonatomic) IBOutlet UILabel *comprehensiveScore;
//@property (weak, nonatomic) IBOutlet UILabel *comprehensiveScore
@end

@implementation CZHotSaleCell

- (void)awakeFromNib {    
    [super awakeFromNib];
    self.tmPrice.attributedText = [@"天猫：¥219.00" addStrikethroughWithRange:[@"天猫：¥219.00" rangeOfString:@"¥219.00"]];
    
    NSString *text = @"推荐理由: 飞利浦电动牙刷hx3216是飞利浦推出入门级产品，采取声波震动技术原理，每分钟23000次/分，1种模式，是初次使用电动牙刷的首选";
    self.recommendReasonLabel.attributedText = [text addAttributeColor:CZREDCOLOR Range:[text rangeOfString:@"推荐理由"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
