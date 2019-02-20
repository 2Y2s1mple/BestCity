//
//  CZHotListController.m
//  BestCity
//
//  Created by JasonBourne on 2019/2/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZHotListController.h"
#import "CZNavigationView.h"
#import "CZOneController.h"

@interface CZHotListController ()

@end

@implementation CZHotListController

- (void)setMainTitle:(NSString *)mainTitle
{
    _mainTitle = mainTitle;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.mainTitle rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.subTitles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    CZHotTitleModel *model = self.subTitles[index];
    if (!self.isList2) {
        NSString *title = [model.categoryName  isEqual: @"综合榜"] ? @"综合" : model.categoryName;
        return title;
    } else {
        return model.categoryName;
    }
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    CZOneController *vc = [[CZOneController alloc] init];
    vc.titleModel = self.subTitles[index];
    vc.isHotList = YES;
    vc.isList2 = self.isList2;
    if (self.isList2) { // 里面的参数是变的
        vc.type = index;
    } else {
        vc.type = self.type;
    }
    return vc;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7) + 50);
}


@end
