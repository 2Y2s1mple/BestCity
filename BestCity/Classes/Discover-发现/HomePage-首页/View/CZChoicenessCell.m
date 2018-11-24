//
//  CZChoicenessCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZChoicenessCell.h"
#import "UIImageView+WebCache.h"

@interface CZChoicenessCell ()
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 主标题 */
@property (nonatomic, weak) IBOutlet UILabel *mainTitle;
/** 附标题 */
@property (nonatomic, weak) IBOutlet UILabel *subTitle;
/** 时间 */
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UIButton *visitLabel;
@end

@implementation CZChoicenessCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"choiceCell";
    CZChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bigImage.layer.cornerRadius = 5;
    self.bigImage.layer.masksToBounds = YES;
}

- (void)setModel:(CZDiscoverDetailModel *)model
{
    _model = model;
    // 大图片
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.imgId] placeholderImage:[UIImage imageNamed:@"testImage6"]];
    // 主标题
    self.mainTitle.text = model.title;
    // 附标题
    self.subTitle.text = model.smallTitle;
    // 时间
    self.timeLabel.text = model.publishTime;
    // 访问量
    [self.visitLabel setTitle:model.visitCount forState:UIControlStateNormal];
}

// 我的界面数据
- (void)setAttentionModel:(CZAttentionDetailModel *)attentionModel
{
    _attentionModel = attentionModel;
    // 大图片
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:attentionModel.img] placeholderImage:[UIImage imageNamed:@"testImage6"]];
    // 主标题
    self.mainTitle.text = attentionModel.title;
    // 附标题
    self.subTitle.text = attentionModel.smallTitle;
    // 时间
    self.timeLabel.text = attentionModel.publishTime;
    // 访问量
    [self.visitLabel setTitle:attentionModel.visitCount forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
    self.attentionModel.cellHeight = CZGetY(self.visitLabel) + 10;
}
@end
