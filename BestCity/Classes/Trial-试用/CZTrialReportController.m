//
//  CZTrialReportController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialReportController.h"
#import "CZNavigationView.h"


@interface CZTrialReportController ()

@end

@implementation CZTrialReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"全部报告" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
}




@end
