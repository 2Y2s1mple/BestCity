//
//  CZEvaluationController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluationController.h"
#import "CZEvaluationChoicenessController.h"

@interface CZEvaluationController ()

@property (nonatomic, strong) NSArray *mainTitles;
@end

@implementation CZEvaluationController

/**
 主标题数组
 */
- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"精选榜", @"个护健康", @"厨卫电器", @"生活家电", @"家用大电"];
    }
    return _mainTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[CZEvaluationChoicenessController alloc] init];
        case 1: return [[CZEvaluationChoicenessController alloc] init];
        case 2: return [[CZEvaluationChoicenessController alloc] init];
        case 3: return [[CZEvaluationChoicenessController alloc] init];
        case 4: return [[CZEvaluationChoicenessController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 20, SCR_WIDTH, HOTTitleH);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 72, SCR_WIDTH, SCR_HEIGHT - 72 - 49);
}

@end
