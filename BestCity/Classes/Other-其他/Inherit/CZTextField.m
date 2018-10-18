//
//  CZTextField.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTextField.h"

@implementation CZTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x += 15;
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 40, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 40, 0);
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.x -= 15;
    return rect;
}


@end
