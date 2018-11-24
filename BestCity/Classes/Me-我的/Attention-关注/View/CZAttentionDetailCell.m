//
//  CZAttentionDetailCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionDetailCell.h"
#import "UIImageView+WebCache.h"

@interface CZAttentionDetailCell ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 图片上的文字 */
@property (nonatomic, weak) IBOutlet UILabel *imageText;
/** 时间 */
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UIButton *visitBtn;
/** 评论 */
@property (nonatomic, weak) IBOutlet UIButton *commentBtn;
@end

@implementation CZAttentionDetailCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"attentionDetailCell";
    CZAttentionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bottomView.layer.cornerRadius = 5;
    self.bottomView.layer.masksToBounds = YES;
}

- (void)setModel:(CZAttentionDetailModel *)model
{
    _model = model;
    // 大图片
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"testImage6"]];
    // 主标题
    self.imageText.text = model.title;
    // 时间
    self.timeLabel.text = model.publishTime;
    // 访问量
    [self.visitBtn setTitle:model.visitCount forState:UIControlStateNormal];
    // lq评论量
    [self.commentBtn setTitle:model.commentNum forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
    self.model.cellHeight = CZGetY(self.commentBtn);
}

@end
