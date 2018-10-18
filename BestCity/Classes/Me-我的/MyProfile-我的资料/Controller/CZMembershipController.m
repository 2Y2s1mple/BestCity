//
//  CZMembershipController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/2.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMembershipController.h"
#import "CZNavigationView.h"

@interface CZMembershipController ()

@end

@implementation CZMembershipController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"会员中心" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
}



@end
