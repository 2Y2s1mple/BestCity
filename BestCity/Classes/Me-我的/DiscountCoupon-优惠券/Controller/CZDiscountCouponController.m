//
//  CZDiscountCouponController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDiscountCouponController.h"
#import "CZNavigationView.h"
#import "CZUseController.h"
#import "CZUnusedController.h"
#import "CZPastDueController.h"

@interface CZDiscountCouponController ()

@property (nonatomic, strong) NSArray *mainTitles;

@end

@implementation CZDiscountCouponController
/**
 主标题数组
 */
- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"未使用", @"已使用", @"已过期"];
    }
    return _mainTitles;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"优惠券" rightBtnTitle:nil rightBtnAction:nil];
    [self.view addSubview:navigationView];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[CZUnusedController alloc] init];
        case 1: return [[CZUseController alloc] init];
        case 2: return [[CZPastDueController alloc] init];
     
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 68, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 68.7 + 50, SCR_WIDTH, SCR_HEIGHT - 68.7 - 49);
}


@end
