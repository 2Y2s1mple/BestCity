//
//  CZCommentDetailView.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/13.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCommentDetailView.h"

@interface CZCommentDetailView ()

@property (nonatomic, strong) UIView *replyView;
@end

@implementation CZCommentDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIView *replyView = [[UIView alloc] init];
    self.replyView = replyView;
    replyView.backgroundColor = CZGlobalLightGray;
    replyView.layer.cornerRadius = 5;
    replyView.layer.masksToBounds = YES;
    replyView.x = 58;
    replyView.width = self.width - replyView.x - 10;
    replyView.height = 0;
    [self addSubview:replyView];
}

- (void)setModel:(CZEvaluateModel *)model
{
    NSInteger maxCommentCount = model.userCommentList.count > 2 ? 2 : model.userCommentList.count;
    
    // 在内容View中加载
    CGFloat replyHeight = 0.0;
    for (NSInteger i = 0; i < maxCommentCount; i++) {
        NSDictionary *dataDic = model.userCommentList[i];
        UILabel *contentLabel = [[UILabel alloc] init];
        [_replyView addSubview:contentLabel];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.numberOfLines = 0;
        contentLabel.x = 10;
        contentLabel.y = 10 + replyHeight;
        contentLabel.width = _replyView.width - 20;
        
        
        NSString *nickName = dataDic[@"fromNickname"] != nil &&  dataDic[@"fromNickname"] != [NSNull null] ? dataDic[@"fromNickname"] : @"***";
        
        NSString *textStr = [NSString stringWithFormat:@"%@ 回复:  %@", nickName, dataDic[@"content"]];
        contentLabel.height = [self getTextHeight:textStr widthRectSize:CGSizeMake(contentLabel.width, 10000)];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:textStr];
        [attriString addAttributes:@{NSForegroundColorAttributeName : CZREDCOLOR} range:[textStr rangeOfString:nickName]];
        contentLabel.attributedText = attriString;
        
        replyHeight += contentLabel.height + 5;
        _replyView.height = CZGetY(contentLabel) + 10;
    }
    
    if (model.userCommentList.count > 2) {
        // 显示更多按钮
        UIButton *moreBtn = [[UIButton alloc] init];
        [_replyView addSubview:moreBtn];
        moreBtn.x = 10;
        moreBtn.y = _replyView.height;
        moreBtn.height = 20;
        moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [moreBtn setTitle:[NSString stringWithFormat:@"共%@条回复", model.secondNum] forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"right-blue"] forState:UIControlStateNormal];
        [moreBtn sizeToFit];
        [moreBtn setNeedsLayout];
        [moreBtn layoutIfNeeded];
        NSLog(@"moreBtn.titleLabel.width - - %f -- %f", moreBtn.titleLabel.width, moreBtn.imageView.width);
        moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, moreBtn.titleLabel.width - moreBtn.imageView.width, 0, 0);
        moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -moreBtn.imageView.width, 0, 0);
        [moreBtn setTitleColor:CZRGBColor(74, 144, 226) forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _replyView.height = CZGetY(moreBtn) + 10;
    }
    self.height = _replyView.height;
}

- (CGFloat)getTextHeight:(NSString *)text widthRectSize:(CGSize)size
{
    CGFloat contentlabelHeight = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    return contentlabelHeight;
}



@end
