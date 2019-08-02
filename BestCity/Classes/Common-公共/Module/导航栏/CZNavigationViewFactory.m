//
//  CZNavigationViewFactory.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZNavigationViewFactory.h"
@interface CZNavigationViewFactory () 

@end

@implementation CZNavigationViewFactory
+ (CZNavigationView *)navigationViewWithTitle:(NSString *)title rightBtn:(id)subTitle rightBtnAction:(void (^)(void))sender delegate:(id <CZNavigationViewDelegate>) delegate
{
    CZNavigationView *nav = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:title rightBtnTitle:subTitle rightBtnAction:sender];
    nav.delegate = delegate;;
    nav.backgroundColor = CZGlobalWhiteBg;
    return nav;
}

@end
