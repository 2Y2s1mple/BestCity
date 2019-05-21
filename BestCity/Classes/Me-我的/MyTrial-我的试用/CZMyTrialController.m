//
//  CZMyTrialController.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/1.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyTrialController.h"
#import "CZNavigationView.h"
#import "CZTrialApplyForController.h" // 申请中
#import "CZTrialApplySuccessController.h" // 申请成功
#import "CZMyTrialApplyForFailedController.h" // 申请失败
#import "CZTrialSuccessReportController.h" // 成功报告

@interface CZMyTrialController ()

@end

@implementation CZMyTrialController

- (void)loadView
{
    [super loadView];
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleLine;
    //        self.progressWidth = 30;
    self.itemMargin = 10;
    self.progressHeight = 3;
    self.automaticallyCalculatesItemWidths = YES;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = CZGlobalGray;
    self.titleColorSelected = CZRGBColor(5, 5, 5);
    self.titleSizeNormal = 15.0f;
    self.titleSizeSelected = 15;
    self.progressColor = CZREDCOLOR;
}

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

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"申请中", @"申请成功", @"申请失败", @"成功报告"];
    return titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0: {
            CZTrialApplyForController *vc = [[CZTrialApplyForController alloc] init];
            return vc;
        }
        case 1: {
            CZTrialApplySuccessController *vc = [[CZTrialApplySuccessController alloc] init];
            return vc;
        }
        case 2: {
            CZMyTrialApplyForFailedController *vc = [[CZMyTrialApplyForFailedController alloc] init];
            return vc;
        }
        case 3: {
            CZTrialSuccessReportController *vc = [[CZTrialSuccessReportController alloc] init];
            return vc;
        }
        default:{
            UIViewController *vc = [[UIViewController alloc] init];
            return vc;
        };
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7) + 50);
}

@end
