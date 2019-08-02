//
//  CZTrialReportController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialReportController.h"
#import "CZNavigationView.h"
#import "CZTrialReportHotController.h"


@interface CZTrialReportController ()
@property (nonatomic, strong) NSArray *mainTitles;
@end

@implementation CZTrialReportController
/**
 主标题数组
 */
- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"最新", @"热门"];
    }
    return _mainTitles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"全部报告" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: { 
            CZTrialReportHotController *vc = [[CZTrialReportHotController alloc] init];
            vc.type = CZTrialReportTypeNew;
            return vc;
        }
        case 1: { 
            CZTrialReportHotController *vc = [[CZTrialReportHotController alloc] init];
            vc.type = CZTrialReportTypeHot;
            return vc;
        }
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(50, NavViewMaxY, SCR_WIDTH - 100, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, NavViewMaxY + 50, SCR_WIDTH, SCR_HEIGHT - NavViewMaxY - 49);
}


@end
