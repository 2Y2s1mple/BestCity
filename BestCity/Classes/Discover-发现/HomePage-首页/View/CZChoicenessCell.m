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
/** 编辑的头像 */
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
/** 编辑的名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UIButton *visitLabel;

/** 最下面的line */
@property (nonatomic, weak) IBOutlet UIView *lineView;
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
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.width / 2.0;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.mainTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
}

- (void)setModel:(CZDiscoverDetailModel *)model
{
    _model = model;
    // 主标题
    self.mainTitle.text = model.title;
    // 大图片
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"testImage6"]];
    // 编辑头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"head1"]];
    // 编辑名字
    self.nameLabel.text = model.user[@"nickname"];
    // 访问量
    [self.visitLabel setTitle:[NSString stringWithFormat:@"%@阅读", model.pv] forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.lineView);
}

// 我的界面数据
//- (void)setAttentionModel:(CZAttentionDetailModel *)attentionModel
//{
//    _attentionModel = attentionModel;
//    // 大图片
//    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:attentionModel.img] placeholderImage:[UIImage imageNamed:@"testImage6"]];
//    // 主标题
//    self.mainTitle.text = attentionModel.title;
//    // 附标题
//    self.subTitle.text = attentionModel.smallTitle;
//    // 时间
//    self.timeLabel.text = attentionModel.publishTime;
//    // 访问量
//    [self.visitLabel setTitle:attentionModel.visitCount forState:UIControlStateNormal];
//    
//    [self layoutIfNeeded];
//    self.attentionModel.cellHeight = CZGetY(self.visitLabel) + 10;
//}
@end
