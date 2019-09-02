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
#import "CZSubCollectThreeController.h"
#import "CZSubCollectFourController.h"
#import "CZSubCollectFiveController.h"


@interface CZCollectController ()

@end

@implementation CZCollectController

- (void)loadView
{
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.itemsWidths = @[@"35", @"35", @"35", @"35", @"65"];
    NSString *margin = [NSString stringWithFormat:@"%lf", (SCR_WIDTH - 35 * 4 - 65 - 30) / 4.0];
    self.itemsMargins = @[@"15", margin, margin, margin, margin, @"15"];
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = CZGlobalGray;
    self.titleColorSelected = [UIColor blackColor];
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 16;
    [super loadView];
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
    return 5;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
//    NSArray *titles = @[@"商品", @"发现", @"评测", @"试用报告"];
    NSArray *titles = @[@"榜单", @"问答", @"评测", @"清单", @"试用报告"];
    return titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
//    1商品，2评测，4试用,5问答，7清单
    switch (index) {
        case 0: {
            CZSubCollectOneController *vc = [[CZSubCollectOneController alloc] init];
            return vc;
        }
        case 1: {
            CZSubCollectTwoController *vc = [[CZSubCollectTwoController alloc] init];
            return vc;
        }
        case 2: {
            CZSubCollectThreeController *vc = [[CZSubCollectThreeController alloc] init];

            return vc;
        }
        case 3: {
            CZSubCollectFourController *vc = [[CZSubCollectFourController alloc] init];

            return vc;
        }
        case 4: {
            CZSubCollectFiveController *vc = [[CZSubCollectFiveController alloc] init];

            return vc;
        }
        default:{
            CZSubCollectTwoController *vc = [[CZSubCollectTwoController alloc] init];
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
