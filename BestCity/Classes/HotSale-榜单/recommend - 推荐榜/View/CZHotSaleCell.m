//
//  CZHotSaleCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotSaleCell.h"
#import "NSString+CZExtension.h"
#import "CZHotScoreModel.h"
#import "UIImageView+WebCache.h"

@interface CZHotSaleCell ()
/** 最上面的序号*/
@property (weak, nonatomic) IBOutlet UILabel *topNumber;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** tag1 */
@property (nonatomic, weak) IBOutlet UILabel *tag1;
/** tag2 */
@property (nonatomic, weak) IBOutlet UILabel *tag2;
/** 当前价格 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/** 省多钱 */
@property (nonatomic, weak) IBOutlet UILabel *cutPriceLabel;
/** 其他平台价格*/
@property (weak, nonatomic) IBOutlet UILabel *tmPrice;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UILabel *visitLabel;
/** 推荐理由 */
@property (nonatomic, weak) IBOutlet UILabel *recommendReasonLabel;
/** 综合评分 */
@property (weak, nonatomic) IBOutlet UILabel *comprehensiveScore;
/** 评分view */
@property (weak, nonatomic) IBOutlet UIView *pointView;
/** 综合评分 */
@property (nonatomic, weak) IBOutlet UILabel *comprehensiveScoreLabel;
/** 评分中第1个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreFirstImageConstraint;
/** 评分中第1个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreFirstName;
/** 评分中第2个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreSecondImageConstraint;
/** 评分中第2个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreSecondName;
/** 评分中第3个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreThreeImageConstraint;
/** 评分中第3个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreThreeName;
/** 评分中第4个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreThirdImageConstraint;
/** 评分中第4个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreThirdName;

@end

@implementation CZHotSaleCell

- (void)awakeFromNib {    
    [super awakeFromNib];}

- (void)setModel:(CZRecommendListModel *)model
{
    _model = model;
    self.topNumber.text = [NSString stringWithFormat:@"%ld", [model.indexNumber integerValue] + 1];
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.rankGoodImg] placeholderImage:[UIImage imageNamed:@"headDefault"]];
    self.titleLabel.text = model.goodsName;
    if (model.goodstypeList.count >= 2) {
        self.tag1.hidden = NO;
        self.tag2.hidden = NO;
        self.tag1.text = model.goodstypeList[0][@"name"];
        self.tag2.text = model.goodstypeList[1][@"name"];
    } else {
        self.tag1.hidden = YES;
        self.tag2.hidden = YES;
    }
    if (model.goodstypeList.count >0) {
        self.tag1.hidden = NO;
        self.tag2.hidden = YES;
        self.tag1.text = model.goodstypeList[0][@"name"];
    } else {
        self.tag1.hidden = YES;
        self.tag2.hidden = YES;
    }
    
    NSString *actualPrice = [NSString stringWithFormat:@"¥%.2f", [model.actualPrice floatValue]];
    self.actualPriceLabel.text = actualPrice;
    self.cutPriceLabel.text = [NSString stringWithFormat:@"省%@", model.cutPrice];
    
    NSString *status;
    switch (model.sourceStatus) {
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
    
    if (model.otherPrice.length > 0) {
        status = [status stringByAppendingFormat:@"    ¥%@", model.otherPrice];
        self.tmPrice.attributedText = [status addStrikethroughWithRange:[status rangeOfString:[NSString stringWithFormat:@"¥%@", model.otherPrice]]];
    }
    
    
    NSInteger visiterCount = [model.visitCount integerValue];
    if (visiterCount > 1000) {
        self.visitLabel.text = [NSString stringWithFormat:@"%0.1f万", visiterCount / 10000.0];
    } else {
        self.visitLabel.text = [NSString stringWithFormat:@"%@", model.visitCount];
    }
    
    
    NSString *text = [NSString stringWithFormat:@"推荐理由:   %@", model.recommendReason];
    NSDictionary *att = @{NSForegroundColorAttributeName : CZREDCOLOR};
    NSDictionary *att1 = @{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size: 13]};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttributes:att range:[text rangeOfString:@"推荐理由"]];
    [attrStr addAttributes:att1 range:[text rangeOfString:text]];
    self.recommendReasonLabel.attributedText = attrStr;
    
    [self layoutIfNeeded];
    // 综合评分
    if (model.goodsScopeList.count >= 4) {
        self.pointView.hidden = NO;
        self.comprehensiveScoreLabel.text = [NSString stringWithFormat:@"%.1f", [model.goodsGrade floatValue]];
        NSInteger maxScore = 150;
        CGFloat everScore = maxScore / 10;
        self.scoreFirstImageConstraint.constant = 150 - [model.goodsScopeList[0].score integerValue] * everScore;
        self.scoreFirstName.text = [model.goodsScopeList[0].name setupTextRowSpace];
        self.scoreSecondImageConstraint.constant = 150 - [model.goodsScopeList[1].score integerValue] * everScore;
        self.scoreSecondName.text = [model.goodsScopeList[1].name setupTextRowSpace];
        self.scoreThreeImageConstraint.constant = 150 - [model.goodsScopeList[2].score integerValue] * everScore;
        self.scoreThreeName.text = [model.goodsScopeList[2].name setupTextRowSpace];
        self.scoreThirdImageConstraint.constant = 150 - [model.goodsScopeList[3].score integerValue] * everScore;
        self.scoreThirdName.text = [model.goodsScopeList[3].name setupTextRowSpace];
        
        model.cellHeight = CGRectGetMaxY(self.pointView.frame);
    } else {
        self.pointView.hidden = YES;
        model.cellHeight = CGRectGetMaxY(self.recommendReasonLabel.frame);
    }
    
    
}

@end
