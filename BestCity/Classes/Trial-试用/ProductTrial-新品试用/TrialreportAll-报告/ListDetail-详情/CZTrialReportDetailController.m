//
//  CZTrialReportDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialReportDetailController.h"
#import "CZNavigationView.h"
@interface CZTrialReportDetailController ()

@end

@implementation CZTrialReportDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"报告详情" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];
}


@end
