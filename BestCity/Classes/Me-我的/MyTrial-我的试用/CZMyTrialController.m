//
//  CZMyTrialController.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/1.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyTrialController.h"
#import "CZNavigationView.h"

@interface CZMyTrialController ()

@end

@implementation CZMyTrialController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我的试用" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    
    
}

@end
