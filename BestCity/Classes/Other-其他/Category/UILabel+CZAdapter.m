//
//  UILabel+CZAdapter.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/10.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "UILabel+CZAdapter.h"
#import <objc/runtime.h>
#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width / 375.0
@implementation UILabel (CZAdapter)
+ (void)load
{
    Method method1 = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method method2 = class_getInstanceMethod([self class], @selector(adapterInitWithCoder:));

//    method_exchangeImplementations(method1, method2);
}

- (instancetype)adapterInitWithCoder:(NSCoder *)aDecoder
{
    [self adapterInitWithCoder:aDecoder];
    if (self) {
        //这里面就不乘以系数了, 因为我重写了font
        self.font = [UIFont systemFontOfSize:self.font.pointSize];
    }
    return self;
}

//这个方法是给xib的UILabel属性加了一个选项, 选项的名字是FixWidthScreenFont参数是(float)fixWidthScreenFont
//- (void)setFixWidthScreenFont:(float)fixWidthScreenFont{
//    
//    if (fixWidthScreenFont > 0 ) {
//        self.font = [UIFont systemFontOfSize:C_WIDTH(fixWidthScreenFont)];
//    }else{
//        self.font = self.font;
//    }
//}
//
//- (float )fixWidthScreenFont{
//    return self.fixWidthScreenFont;
//}

@end
