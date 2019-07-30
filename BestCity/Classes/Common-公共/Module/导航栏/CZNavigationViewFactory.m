//
//  CZNavigationViewFactory.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZNavigationViewFactory.h"

@implementation CZNavigationViewFactory
+ (CZNavigationView *)navigationViewWithTitle:(NSString *)title rightBtn:(id)subTitle rightBtnAction:(void (^)(void))sender
{
    CZNavigationView *nav = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:title rightBtnTitle:subTitle rightBtnAction:sender navigationViewType:CZNavigationViewTypeBlack];
    nav.backgroundColor = CZGlobalWhiteBg;
    return nav;
}
@end
