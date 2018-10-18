//
//  UIFont+CZExtension.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/10.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "UIFont+CZExtension.h"
#import <objc/runtime.h>

@implementation UIFont (CZExtension)

+ (void)load
{
    Method method1 = class_getClassMethod([self class], @selector(systemFontOfSize:));
    Method method2 = class_getClassMethod([self class], @selector(myFontOfSize:));

    method_exchangeImplementations(method1, method2);
}

+ (UIFont *)myFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont myFontOfSize:FSS(fontSize)];
    return font;
}
@end
