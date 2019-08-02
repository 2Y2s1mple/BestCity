//
//  CZCollectController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCollectController.h"
#import "CZNavigationView.h"
#import "CZSubCollectOneController.h"
#import "CZSubCollectTwoController.h"


@interface CZCollectController ()

@end

@implementation CZCollectController

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
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我的收藏" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];
}

- (void)popAction
{
    // 隐藏菊花
    [CZProgressHUD hideAfterDelay:0];    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"商品", @"发现", @"评测", @"试用报告"];
    return titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0: {
            CZSubCollectOneController *vc = [[CZSubCollectOneController alloc] init];
            return vc;
        }
        case 1: {
            CZSubCollectTwoController *vc = [[CZSubCollectTwoController alloc] init];
            vc.type = CZJIPINModuleDiscover;
            return vc;
        }
        case 2: {
            CZSubCollectTwoController *vc = [[CZSubCollectTwoController alloc] init];
            vc.type = CZJIPINModuleEvaluation;
            return vc;
        }
        default:{
            CZSubCollectTwoController *vc = [[CZSubCollectTwoController alloc] init];
            vc.type = CZJIPINModuleTrail;
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
