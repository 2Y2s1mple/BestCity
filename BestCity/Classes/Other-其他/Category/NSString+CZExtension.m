//
//  NSString+CZExtension.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/9.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "NSString+CZExtension.h"

@implementation NSString (CZExtension)

//返回一个中划线的富文本
- (NSMutableAttributedString *)addStrikethroughWithRange:(NSRange)range
{
    NSDictionary *att = @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr addAttributes:att range:range];
    return attrStr;
}

//添加文字颜色
- (NSMutableAttributedString *)addAttributeColor:(UIColor *)color Range:(NSRange)range
{
    NSDictionary *att = @{NSForegroundColorAttributeName : color};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr addAttributes:att range:range];
    return attrStr;
}

//添加文字大小
- (NSMutableAttributedString *)addAttributeFont:(UIFont *)Font Range:(NSRange)range
{
    NSDictionary *att = @{NSFontAttributeName : Font};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr addAttributes:att range:range];
    return attrStr;
}

// 添加各种属性
- (NSMutableAttributedString *)addAttribute:(NSDictionary *)attributs Range:(NSRange)range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attrStr addAttributes:attributs range:range];
    return attrStr;
}

// 设置文字间距
- (NSString *)setupTextRowSpace
{
    NSString *string;
    if (self.length == 3) {
        string = [NSString stringWithFormat:@"%@  %@  %@", [self substringWithRange:NSMakeRange(0, 1)], [self substringWithRange:NSMakeRange(1, 1)], [self substringWithRange:NSMakeRange(2, 1)] ];
    } else if (self.length == 2) {
        string = [NSString stringWithFormat:@"%@        %@", [self substringWithRange:NSMakeRange(0, 1)], [self substringWithRange:NSMakeRange(1, 1)]];
    } else {
        string = self;
    }
    return string;
}

- (CGFloat)getTextHeightWithRectSize:(CGSize)size andFont:(UIFont *)font
{
    CGFloat contentlabelHeight = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size.height;
    return contentlabelHeight;
}

@end
