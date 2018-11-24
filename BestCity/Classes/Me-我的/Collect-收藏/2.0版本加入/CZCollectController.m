//
//  CZCollectController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCollectController.h"
#import "CZNavigationView.h"
#import "CZFootprintController.h"

@interface CZCollectController ()

@property (nonatomic, strong) NSArray *mainTitles;

@end

@implementation CZCollectController

/**
 主标题数组
 */
- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"收藏", @"足迹"];
    }
    return _mainTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"收藏/足迹" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + 68, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[CZFootprintController alloc] init];
        case 1: return [[CZFootprintController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(100, 68, SCR_WIDTH - 200, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 68.7 + 50, SCR_WIDTH, SCR_HEIGHT - 68.7 - 49);
}
@end
