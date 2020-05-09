//
//  CZAllOrderController.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAllOrderController.h"
//#import "CZNavigationView.h"
#import "CZAllOrderSubOne.h"


@interface CZAllOrderController () <WMMenuViewDataSource, WMMenuViewDelegate, WMMenuItemDelegate>

@end

@implementation CZAllOrderController

- (void)loadView
{
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleDefault;
    //        hotVc.progressWidth = 30;
    self.itemMargin = 10;
//    self.progressHeight = 28;
//    self.progressWidth = 71;
//    self.progressViewCornerRadius = 3;
    self.automaticallyCalculatesItemWidths = YES;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorNormal = UIColorFromRGB(0x989898);
    self.titleColorSelected = UIColorFromRGB(0xE25838);
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 14;
    [super loadView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xF5F5F5);
    line.width = SCR_WIDTH;
    line.height = 10;
    [self.view addSubview:line];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"全部", @"即将到账", @"已到账", @"失效订单"];
    return titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
//    状态（0全部,1即将到账，2已到账，3订单失效）
    switch (index) {
        case 0: {
            CZAllOrderSubOne *vc = [[CZAllOrderSubOne alloc] init];
            vc.source = self.source;
            vc.status = @"0";
            return vc;
        }
        case 1: {
            CZAllOrderSubOne *vc = [[CZAllOrderSubOne alloc] init];
            vc.source = self.source;
            vc.status = @"1";
            return vc;
        }
        case 2: {
            CZAllOrderSubOne *vc = [[CZAllOrderSubOne alloc] init];
            vc.source = self.source;
            vc.status = @"2";
            return vc;
        }
        case 3: {
            CZAllOrderSubOne *vc = [[CZAllOrderSubOne alloc] init];
            vc.source = self.source;
            vc.status = @"3";
            return vc;
        }
        default:{
            UIViewController *vc = [[UIViewController alloc] init];
            return vc;
        };
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 10, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, 60, SCR_WIDTH, self.view.height - 50 - 10);
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"---%@---", info[@"title"]];
    NSLog(@"----%@", text);
}

- (WMMenuItem *)menuView:(WMMenuView *)menu initialMenuItem:(WMMenuItem *)initialMenuItem atIndex:(NSInteger)index
{
    WMMenuItem *Item = initialMenuItem;
    Item.layer.borderWidth = 0.5;
    Item.layer.borderColor = UIColorFromRGB(0x989898).CGColor;
    Item.layer.cornerRadius = 3;
    return Item;
}

- (void)menuView:(WMMenuView *)menu didLayoutItemFrame:(WMMenuItem *)menuItem atIndex:(NSInteger)index
{
    menuItem.height = 28;
    menuItem.centerY = 25;
    NSLog(@"%@", NSStringFromCGRect(menuItem.frame));
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index
{
    return 71;
}

- (void)menuView:(WMMenuView *)menu didSelectedItem:(WMMenuItem *)indexItem currentItem:(WMMenuItem *)currentItem
{
    
    indexItem.layer.borderColor = UIColorFromRGB(0xE25838).CGColor;
    if (indexItem != currentItem){
        currentItem.layer.borderColor = UIColorFromRGB(0x989898).CGColor;
    }
}


@end
