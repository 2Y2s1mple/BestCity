//
//  CZFreeOrderController.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeOrderController.h"
#import "CZNavigationView.h"
#import "CZFreeOrderSubOne.h"
#import "CZFreeOrderSubTwo.h"
#import "CZFreeOrderSubThree.h"
#import "CZFreeOrderSubFour.h"

@interface CZFreeOrderController ()

@end

@implementation CZFreeOrderController
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
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
       CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我的免单" rightBtnTitle:nil rightBtnAction:nil ];
       [self.view addSubview:navigationView];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
//    NSArray *titles = @[@"商品", @"发现", @"评测", @"试用报告"];
    NSArray *titles = @[@"待付款", @"待返现", @"已完成", @"已失效"];
    return titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
//    1商品，2评测，4试用,5问答，7清单
    switch (index) {
        case 0: {
            CZFreeOrderSubOne *vc = [[CZFreeOrderSubOne alloc] init];
            return vc;
        }
        case 1: {
            CZFreeOrderSubTwo *vc = [[CZFreeOrderSubTwo alloc] init];
            return vc;
        }
        case 2: {
            CZFreeOrderSubThree *vc = [[CZFreeOrderSubThree alloc] init];

            return vc;
        }
        case 3: {
            CZFreeOrderSubFour *vc = [[CZFreeOrderSubFour alloc] init];

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

    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7) - 50);
}


@end
