//
//  NSString+CZExtension.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/9.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CZExtension)
- (NSMutableAttributedString *)addStrikethroughWithRange:(NSRange)range;

- (NSMutableAttributedString *)addAttributeColor:(UIColor *)color Range:(NSRange)range;

- (NSString *)setupTextRowSpace;
- (CGFloat)getTextHeightWithRectSize:(CGSize)size andFont:(UIFont *)font;
@end
