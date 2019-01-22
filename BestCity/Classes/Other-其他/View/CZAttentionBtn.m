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
    btn.frame = CGRectMake(0, 0, 60, 24);
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 13;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    [btn addTarget:backView action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    switch (type) {
        case CZAttentionBtnTypeTogether:
            btn.backgroundColor = CZGlobalLightGray;
            btn.layer.borderColor = CZGlobalLightGray.CGColor;
            [btn setTitle:@"相互关注" forState:UIControlStateNormal];
            [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
            btn.selected = YES;
            break;
        case CZAttentionBtnTypeFollowed:
            btn.backgroundColor = CZGlobalLightGray;
            btn.layer.borderColor = CZGlobalLightGray.CGColor;
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
            btn.selected = YES;
            break;
        case CZAttentionBtnTypeAttention:
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = CZREDCOLOR.CGColor;
            [btn setTitle:@"+关注" forState:UIControlStateNormal];
            [btn setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
            btn.selected = NO;
            break;
        default:
            break;
    }
    
    return backView;
}

- (void)didClickedBtn:(UIButton *)sender
{
    sender.enabled = NO;
    sender.selected = !sender.selected;
    self.block(sender.selected);
}

- (void)setType:(CZAttentionBtnType)type
{
    _type = type;
    UIButton *btn = [self.subviews lastObject];
    btn.enabled = YES;
    switch (type) {
        case CZAttentionBtnTypeTogether:
            btn.backgroundColor = CZGlobalLightGray;
            btn.layer.borderColor = CZGlobalLightGray.CGColor;
            [btn setTitle:@"相互关注" forState:UIControlStateNormal];
            [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
            btn.selected = YES;
            break;
        case CZAttentionBtnTypeFollowed:
            btn.backgroundColor = CZGlobalLightGray;
            btn.layer.borderColor = CZGlobalLightGray.CGColor;
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
            btn.selected = YES;
            break;
        case CZAttentionBtnTypeAttention:
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = CZREDCOLOR.CGColor;
            [btn setTitle:@"+关注" forState:UIControlStateNormal];
            [btn setTitleColor:CZREDCOLOR forState:UIControlStateNormal];
            btn.selected = NO;
            break;
        default:
            break;
    }
}
@end
