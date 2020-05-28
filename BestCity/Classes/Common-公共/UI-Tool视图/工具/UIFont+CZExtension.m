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
//    Method method1 = class_getClassMethod([self class], @selector(systemFontOfSize:));
//    Method method2 = class_getClassMethod([self class], @selector(myFontOfSize:));

//    method_exchangeImplementations(method1, method2);
    
    
//    Method method3 = class_getClassMethod([self class], @selector(fontWithName:size:));
//    Method method4 = class_getClassMethod([self class], @selector(myFontWithName:size:));
//    method_exchangeImplementations(method3, method4);
}

+ (UIFont *)myFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont myFontOfSize:FSS(fontSize)];
    return font;
}

//+ (UIFont *)myFontWithName:(NSString *)fontName size:(CGFloat)fontSize
//{
//    if (@available(iOS 9.0, *)) {
//        UIFont *font = [UIFont myFontWithName:fontName size:fontSize];
//        return font;
//    } else {
//        UIFont *font = [UIFont systemFontOfSize:fontSize];
//        return font;
//    }
//}


@end
