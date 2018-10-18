//
//  CZLabel.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/9.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZLabel.h"

@interface CZLabel ()

@end

@implementation CZLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
