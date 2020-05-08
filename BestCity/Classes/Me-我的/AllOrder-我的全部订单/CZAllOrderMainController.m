//
//  CZAllOrderMainController.m
//  BestCity
//
//  Created by JsonBourne on 2020/4/30.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAllOrderMainController.h"
#import "CZNavigationView.h"
#import "CZAllOrderController.h"

@interface CZAllOrderMainController ()

@end

@implementation CZAllOrderMainController

- (void)loadView
{
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.menuViewStyle = WMMenuViewStyleLine;
    //        hotVc.progressWidth = 30;
    self.itemMargin = 10;
    self.progressHeight = 3;
    self.automaticallyCalculatesItemWidths = YES;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = CZGlobalGray;
    self.titleColorSelected = UIColorFromRGB(0xE25838);
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 16;
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我的订单" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"全部订单", @"淘宝", @"京东", @"拼多多"];
    return titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    // 商品来源(0全部,1京东,2淘宝，4拼多多)
    switch (index) {
        case 0: {
            CZAllOrderController *vc = [[CZAllOrderController alloc] init];
            vc.source = @"0";
            return vc;
        }
        case 1: {
            CZAllOrderController *vc = [[CZAllOrderController alloc] init];
            vc.source = @"2";
            return vc;
        }
        case 2: {
            CZAllOrderController *vc = [[CZAllOrderController alloc] init];
            vc.source = @"1";
            return vc;
        }
        case 3: {
            CZAllOrderController *vc = [[CZAllOrderController alloc] init];
            vc.source = @"4";
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

    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? (24 + 34) : 0) + 67.7) - 50);
}


@end
