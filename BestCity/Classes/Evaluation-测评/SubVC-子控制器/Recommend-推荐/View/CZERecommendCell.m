//
//  CZERecommendCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZERecommendCell.h"
#import "CZERecommendItemViewModel.h"
#import "UIImageView+WebCache.h"

@interface CZERecommendCell ()
/** 主标题 */
@property (nonatomic, weak) IBOutlet UILabel *mainTitle;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImage;
/** 编辑的头像 */
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
/** 编辑的名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 个性签名 */
@property (nonatomic, weak) IBOutlet UILabel *signatureLabel;
/** 访问量 */
@property (nonatomic, weak) IBOutlet UILabel *visitLabel;
/** 最下面的line */
@property (nonatomic, weak) IBOutlet UIView *lineView;
/** 关注按钮 */
@property (nonatomic, weak) IBOutlet UIButton *attentionBtn;
/** 视图模型 */
@property (nonatomic, strong) CZERecommendItemViewModel *viewModel;
@end

@implementation CZERecommendCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZERecommendCell";
    CZERecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZERecommendCell class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)bindViewModel:(CZERecommendItemViewModel *)viewModel
{
    self.viewModel = viewModel;
    /** 主标题 */
    self.mainTitle.text = self.viewModel.model.title;
    /** 大图片 */
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.img]];
    /** 编辑的头像 */
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.user.avatar]];
    /** 编辑的名字 */
    self.nameLabel.text = self.viewModel.model.user.nickname;
    /** 个性签名 */
    self.signatureLabel.text = self.viewModel.model.user.detail;
    /** 访问量 */
    self.visitLabel.text = [NSString stringWithFormat:@"%@阅读",  self.viewModel.model.pv];
    // 设置关注按钮
    if ([self.viewModel.model.user.follow boolValue]) {
        [self attentionBtnStyle:self.attentionBtn];
    } else {
        [self notAttentionBtnStyle:self.attentionBtn];
    }

    [self layoutIfNeeded];
    /** 最下面的line */
    self.viewModel.cellHeight = CZGetY(self.lineView);
}

- (void)attentionAction:(UIButton *)sender
{
    if (![self.viewModel.model.user.follow boolValue]) {
        [CZJIPINSynthesisTool addAttentionWithID:self.viewModel.model.user.userId action:^{
            [self attentionBtnStyle:self.attentionBtn];
//            self.viewModel.model.user.follow = @"1";
            self.cellWithBlcok(self.viewModel.model.user.userId, YES);
        }];
    } else {
        [CZJIPINSynthesisTool deleteAttentionWithID:self.viewModel.model.user.userId action:^{
            [self notAttentionBtnStyle:self.attentionBtn];
//            self.viewModel.model.user.follow = @"0";
            self.cellWithBlcok(self.viewModel.model.user.userId, NO);
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.mainTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.attentionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    [self.attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 未关注样式
- (void)notAttentionBtnStyle:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    sender.layer.borderColor = UIColorFromRGB(0xE25838).CGColor;
    [sender setTitle:@"关 注" forState:UIControlStateNormal];
    [sender setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateNormal];
}

// 已关注样式
- (void)attentionBtnStyle:(UIButton *)sender
{
    sender.layer.borderColor = CZGlobalGray.CGColor;
    [sender setTitle:@"已关注" forState:UIControlStateNormal];
    [sender setTitleColor:CZGlobalGray forState:UIControlStateNormal];
}
@end
