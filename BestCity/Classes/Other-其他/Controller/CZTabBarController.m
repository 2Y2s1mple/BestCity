//
//  CZTabBarController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTabBarController.h"
#import "CZHotSaleController.h"
#import "CZDiscoverController.h"
#import "CZEvaluationController.h"
#import "CZMeController.h"
#import "CZNavigationController.h"

@interface CZTabBarController ()

@end

@implementation CZTabBarController

+(void)initialize
{
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = CZRGBColor(40, 40, 40);
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = CZRGBColor(277, 20, 54);
    selectedAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    [[UITabBarItem appearance] setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor: CZRGBColor(254, 254, 254)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWithController:[[CZHotSaleController alloc] init] title:@"榜单" image:@"tab-upstage-nor" selectedImage:@"tab-upstage-sel"];
    [self setupWithController:[[CZDiscoverController alloc] init] title:@"发现" image:@"tab-discover-nor" selectedImage:@"tab-discover-sel"];
    [self setupWithController:[[CZEvaluationController alloc] init] title:@"评测" image:@"tab-edit-nor" selectedImage:@"tab-edit-sel"];
    [self setupWithController:[[CZMeController alloc] init] title:@"我的" image:@"tab-people-nor" selectedImage:@"tab-people-sel"];
    
    self.selectedIndex = 0;
    self.tabBar.clipsToBounds = YES;
}

- (void)setupWithController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    if (![vc isKindOfClass:[CZMeController class]]) {
        WMPageController *hotVc = (WMPageController *)vc;
        hotVc.selectIndex = 0;
        hotVc.menuViewStyle = WMMenuViewStyleLine;
        hotVc.automaticallyCalculatesItemWidths = YES;
//        hotVc.titleFontName = @"PingFangSC-Medium";
        hotVc.titleColorNormal = CZGlobalGray;
        hotVc.titleColorSelected = CZRGBColor(5, 5, 5);
        hotVc.titleSizeNormal = 16.0f;
        hotVc.titleSizeSelected = hotVc.titleSizeNormal;
        hotVc.progressColor = [UIColor redColor];
    }
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:vc];
    [vc.navigationController setNavigationBarHidden:YES];
    [self addChildViewController:nav];
}

@end
