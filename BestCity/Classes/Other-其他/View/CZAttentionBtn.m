//
//  CZAttentionBtn.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionBtn.h"

@interface CZAttentionBtn ()
/** 记录代码 */
@property (nonatomic, copy) AttentionAction block;
@end

@implementation CZAttentionBtn

+ (instancetype)attentionBtnWithframe:(CGRect)frame CommentType:(CZAttentionBtnType)type didClickedAction:(AttentionAction)action
{
    CZAttentionBtn *backView = [[self alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 60, 24)];
    backView.block = action;
    
    //关注按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"+关注" forState:UIControlStateNormal];
    [btn setTitle:@"已关注" forState:UIControlStateSelected];
    btn.frame = CGRectMake(0, 0, 60, 24);
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitleColor:CZGlobalGray forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 13;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    [btn addTarget:backView action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    switch (type) {
        case CZAttentionBtnTypeFollowed:
            btn.backgroundColor = CZGlobalLightGray;
            btn.layer.borderColor = CZGlobalLightGray.CGColor;
            btn.selected = YES;
            break;
        case CZAttentionBtnTypeAttention:
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.selected = NO;
            break;
        default:
            break;
    }
    
    return backView;
}

- (void)didClickedBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        sender.backgroundColor = CZGlobalLightGray;
        sender.layer.borderColor = CZGlobalLightGray.CGColor;
    } else {
        sender.backgroundColor = [UIColor whiteColor];
        sender.layer.borderColor = [UIColor redColor].CGColor;
    }
    self.block(sender.selected);
}

- (void)setType:(CZAttentionBtnType)type
{
    _type = type;
    UIButton *btn = [self.subviews lastObject];
    switch (type) {
        case CZAttentionBtnTypeFollowed:
            btn.backgroundColor = CZGlobalLightGray;
            btn.layer.borderColor = CZGlobalLightGray.CGColor;
            btn.selected = YES;
            break;
        case CZAttentionBtnTypeAttention:
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = [UIColor redColor].CGColor;
            btn.selected = NO;
            break;
        default:
            break;
    }
}
@end
