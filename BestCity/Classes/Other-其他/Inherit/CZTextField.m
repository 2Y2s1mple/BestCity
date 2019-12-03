//
//  CZTextField.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTextField.h"

@implementation CZTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xD8D8D8);
        self.font = [UIFont systemFontOfSize:14];
//        self.layer.cornerRadius = 6;
        self.textColor = UIColorFromRGB(0x565252);
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = UIColorFromRGB(0xACACAC).CGColor ;
//        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"搜索商品榜"];
//        [placeholder addAttribute:NSFontAttributeName
//                            value:[UIFont fontWithName:@"PingFangSC-Regular" size: 13]
//                            range:NSMakeRange(0, 5)];
        self.placeholder = @"搜商品名称或粘贴标题";
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索-2"]];
        self.leftView = image;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.returnKeyType = UIReturnKeySearch;
    }
    return self;
}

/**
 * 控制左侧视图位置
 */
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x += 15;
    return rect;
}

/**
 * 提示文字的位置
 */
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 45, 0);
}

/**
 * 编辑文字的位置
 */
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    
    return CGRectInset(bounds, 45, 0);
}

/**
 * 控制右侧视图位置,这里也就是删除按钮
 */
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.x -= 15;
    return rect;
}


@end
