//
//  CZCommentMoreCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/14.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCommentMoreCell.h"

@interface CZCommentMoreCell ()
/** 评论 */
@property (nonatomic, strong) UIButton *moreBtn;
/** 背景view */
@property (nonatomic, strong) UIView *backView;
@end

@implementation CZCommentMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = CZGlobalWhiteBg;;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupProperty];
    }
    return self;
}

- (void)setupProperty
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = CZGlobalLightGray;
    [self.contentView addSubview:self.backView];
    
    // 显示更多按钮
    UIButton *moreBtn = [[UIButton alloc] init];
    self.moreBtn = moreBtn;
    [self.backView addSubview:moreBtn];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [moreBtn setTitleColor:CZRGBColor(74, 144, 226) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.frame = CGRectMake(58, 0, SCR_WIDTH - 86, 0);
    
    self.moreBtn.x = 10;
    self.moreBtn.y = 10;
    self.moreBtn.height = 20;
    self.moreBtn.width = 100;
    self.backView.height = CZGetY(self.moreBtn) + 10;
}

- (void)setCount:(NSString *)count
{
    _count = count;
    [self.moreBtn setTitle:[NSString stringWithFormat:@"共%@条回复", count] forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageNamed:@"right-blue"] forState:UIControlStateNormal];
    self.moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.moreBtn.titleLabel.width + self.moreBtn.imageView.width, 0, 0);
    self.moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.moreBtn.imageView.width, 0, 0);
}

- (void)moreBtnAction
{
    !self.delegate ? : [self.delegate loadMoreBtnWithIndexPath:self.currentIndexPath];
}

@end
