//
//  CZAllHotListController.m
//  BestCity
//
//  Created by JasonBourne on 2019/2/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAllHotListController.h"
#import "CZNavigationView.h"
#import "CZTwoController.h"
#import "CZHotSubTilteModel.h"

@interface CZAllHotListController ()

@end

@implementation CZAllHotListController

- (void)setUpPorperty
{
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.itemMargin = 10;
    self.automaticallyCalculatesItemWidths = YES;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = CZGlobalGray;
    self.titleColorSelected = CZREDCOLOR;
    self.titleSizeNormal = 15.0f;
    self.titleSizeSelected = 15;
}

- (void)setSubTitlesModel:(CZHotTitleModel *)subTitlesModel
{
    _subTitlesModel = subTitlesModel;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:subTitlesModel.categoryName rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
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
    
    return self.subTitlesModel.children.count + 1;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"全部";
    } else {
        CZHotSubTilteModel *subTitleModel = self.subTitlesModel.children[index - 1];
        return subTitleModel.categoryName;
    }
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    CZTwoController *vc = [[CZTwoController alloc] init];
     vc.isAllHotList = YES;
    vc.subTitles = self.subTitlesModel;
    vc.index = index;
    return vc;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7) + 50);
}


@end
