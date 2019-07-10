//
//  CZMHSDListNewCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDListNewCell.h"
#import "UIImageView+WebCache.h"

@interface CZMHSDListNewCell ()
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

@end

@implementation CZMHSDListNewCell

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
    model.cellHeight = CZGetY(self.visitLabel) + 20;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
