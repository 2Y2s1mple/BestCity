//
//  CZRWBindingView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/24.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRWBindingView.h"

@implementation CZRWBindingView
+ (instancetype)RWBindingView
{
    CZRWBindingView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.width = SCR_WIDTH;
    return view;
}



// 绑定账号
- (IBAction)bingzhifubao
{
    NSLog(@"绑定支付宝");

}

@end
