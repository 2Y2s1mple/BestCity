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

@end
