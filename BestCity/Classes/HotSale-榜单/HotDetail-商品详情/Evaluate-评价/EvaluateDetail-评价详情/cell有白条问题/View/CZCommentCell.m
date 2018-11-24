//
//  CZCommentCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/14.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCommentCell.h"

@interface CZCommentCell ()
/** 评论 */
@property (nonatomic, strong) UILabel *commentLabel;
@end

@implementation CZCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = CZGlobalLightGray;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupProperty];
    }
    return self;
}

- (void)setupProperty
{
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.commentLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setModel:(CZCommentModel *)model
{
    _model = model;
    
    // 设置评论内容
    self.commentLabel.attributedText = model.attriString;
    [self layoutIfNeeded];
    self.commentLabel.frame = CGRectMake(10, 10, self.contentView.width - 20, model.labelHeight);
}

@end
