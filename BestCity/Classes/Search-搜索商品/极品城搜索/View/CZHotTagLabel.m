//
//  CZHotTagLabel.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/5.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZHotTagLabel.h"

@implementation CZHotTagLabel
#pragma mark - 属性
- (void)setType:(CZHotTagLabelType)type
{
    _type = type;
    [self setup:type];
}

#pragma mark - 初始化
- (void)setup:(CZHotTagLabelType)type
{
    self.font = [UIFont systemFontOfSize:15];
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = UIColorFromRGB(0x565252);

    self.userInteractionEnabled = YES;
    if (type == CZHotTagLabelTypeTapGesture) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        [self addGestureRecognizer:tap];
    } else if (type == CZHotTagLabelTypeLongPressGesture) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
        [self addGestureRecognizer:longPress];
    } else {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        [self addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
        [self addGestureRecognizer:longPress];
    }
}

- (void)setText:(NSString *)text
{
    NSLog(@"%@", text);
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"　" withString:@""];
    [super setText:text];
}

#pragma mark - 事件
// 轻拍手势
- (void)tapEvent:(UITapGestureRecognizer *)tap
{
    !self.delegate ? : [self.delegate hotTagLabelWithTapEvent:self];
}

// 长按手势
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPressGest
{
    UILabel *label = (UILabel *)longPressGest.view;
    if (longPressGest.state == UIGestureRecognizerStateBegan) {
        //创建一个删除按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"search-close"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        [[label superview] addSubview:btn];
        btn.frame = CGRectMake(CZGetX(label) - 10, CGRectGetMinY(label.frame) - 5, 15, 15);
    }
}

// 长按手势的事件
- (void)btnCloseAction:(UIButton *)btn
{
    !self.delegate ? : [self.delegate hotTagLabel:self longPressAccessoryEvent:btn];
}

@end
