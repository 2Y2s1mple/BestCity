//
//  CZHotSaleCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotSaleCell.h"
#import "NSString+CZExtension.h"
#import "UIImageView+WebCache.h"

@interface CZHotSaleCell ()
/** 最上面的序号*/
@property (nonatomic, weak) IBOutlet UILabel *topNumberDefault;
@property (weak, nonatomic) IBOutlet UILabel *topNumber;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
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
/** 其他平台价格*/
@property (weak, nonatomic) IBOutlet UILabel *tmPrice;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UILabel *visitLabel;
/** 推荐理由 */
@property (nonatomic, weak) IBOutlet UILabel *recommendReasonLabel;

@end

@implementation CZHotSaleCell

- (void)awakeFromNib {    
    [super awakeFromNib];
    self.topNumberDefault.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 23];
    self.topNumber.font = self.topNumberDefault.font;
}

- (void)setModel:(CZRecommendListModel *)model
{
    _model = model;
    self.topNumber.text = [NSString stringWithFormat:@"%ld", [model.indexNumber integerValue] + 1];
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.titleLabel.text = model.goodsName;
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    self.tag4.hidden = YES;
    
    for (int i = 0; i < model.goodsTagsList.count; i++) {
        switch (i) {
            case 0:
                [self.tag1 setTitle:model.goodsTagsList[i][@"name"] forState:UIControlStateNormal];
                self.tag1.hidden = NO;
                self.tag2.hidden = YES;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                break;
            case 1:
                [self.tag2 setTitle:model.goodsTagsList[i][@"name"] forState:UIControlStateNormal];
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                break;
            case 2:
                [self.tag3 setTitle:model.goodsTagsList[i][@"name"] forState:UIControlStateNormal];
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = YES;
                break;
            case 3:
                [self.tag4 setTitle:model.goodsTagsList[i][@"name"] forState:UIControlStateNormal];
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = NO;
                break;
            default:
                break;
        }
    }
    
    
    NSString *actualPrice = [NSString stringWithFormat:@"¥%.2f", [model.actualPrice floatValue]];
    self.actualPriceLabel.text = actualPrice;
    self.actualPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    
    NSString *status;
    switch ([model.source integerValue]) {
        case 0:
            status = @"原价:";
            break;
        case 1:
            status = @"京东:";
            break;
        case 2:
            status = @"淘宝:";
            break;
        case 3:
            status = @"天猫:";
            break;
        default:
            status = @"";
            break;
    }
    
    if (model.otherPrice.length > 0 && ![model.actualPrice isEqualToString:model.otherPrice]) {
        self.tmPrice.hidden = NO;
        status = [status stringByAppendingFormat:@" ¥%@", model.otherPrice];
        self.tmPrice.attributedText = [status addStrikethroughWithRange:[status rangeOfString:[NSString stringWithFormat:@"¥%@", model.otherPrice]]];
    } else {
        self.tmPrice.hidden = YES;
    }
    
    
    NSInteger visiterCount = [model.pv integerValue];
    if (visiterCount > 1000) {
        self.visitLabel.text = [NSString stringWithFormat:@"%0.1f万", visiterCount / 10000.0];
    } else {
        self.visitLabel.text = [NSString stringWithFormat:@"%@", model.pv];
    }
    
    // 推荐理由
    NSString *text = [NSString stringWithFormat:@"推荐理由: %@", model.recommendReason];
    self.recommendReasonLabel.textColor = UIColorFromRGB(0x151515);
    self.recommendReasonLabel.attributedText = [text addAttributeColor:[UIColor blackColor] Range:[text rangeOfString:@"推荐理由"]];

    [self layoutIfNeeded];
    model.cellHeight = CGRectGetMaxY(self.recommendReasonLabel.frame) + 20;
    
}

@end
