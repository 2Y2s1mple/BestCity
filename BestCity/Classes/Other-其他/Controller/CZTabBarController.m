//
//  CZTabBarController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTabBarController.h"

#import "CZMainHotSaleController.h"

#import "CZDiscoverController.h"
#import "CZEvaluationController.h"
#import "CZTrialMainController.h"
#import "CZMeController.h"
#import "CZNavigationController.h"
#import "CZLoginController.h"

#import "CZMainHotSaleDetailController.h"


@interface CZTabBarController ()<UITabBarControllerDelegate>

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
    // 设配iOS12, tabbar抖动问题
    [[UITabBar appearance] setTranslucent:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;

    [self setupWithController:[[CZMainHotSaleDetailController alloc] init] title:@"榜单" image:@"tab-upstage-nor" selectedImage:@"tab-upstage-sel"];



//    [self setupWithController:[[CZMainHotSaleController alloc] init] title:@"榜单" image:@"tab-upstage-nor" selectedImage:@"tab-upstage-sel"];
    [self setupWithController:[[CZDiscoverController alloc] init] title:@"发现" image:@"tab-discover-nor" selectedImage:@"tab-discover-sel"];
    [self setupWithController:[[CZEvaluationController alloc] init] title:@"评测" image:@"tab-edit-nor" selectedImage:@"tab-edit-sel"];
    [self setupWithController:[[CZTrialMainController alloc] init] title:@"试用" image:@"tab-try-nor" selectedImage:@"tab-try-sel"];
    [self setupWithController:[[CZMeController alloc] init] title:@"我的" image:@"tab-people-nor" selectedImage:@"tab-people-sel"];
    
    self.selectedIndex = 0;
    self.tabBar.clipsToBounds = YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

    NSArray *configureList = @[ @"tab栏榜单", @"tab栏发现", @"tab栏评测", @"tab栏试用", @"tab栏我的"];
    NSString *ID = [NSString stringWithFormat:@"ID%ld", (tabBarController.selectedIndex + 1)];
    NSDictionary *context = configureList[tabBarController.selectedIndex];
    [MobClick event:ID attributes:@{@"Tab" : context}];

    NSLog(@"%lu", (unsigned long)tabBarController.selectedIndex);
    if ([JPTOKEN length] <= 0 && tabBarController.selectedIndex == 4) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {}
    ;
}

- (void)setupWithController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    if (![vc isKindOfClass:[CZMeController class]] && ![vc isKindOfClass:[CZMainHotSaleDetailController class]]) {
        WMPageController *hotVc = (WMPageController *)vc;
        hotVc.selectIndex = 0;
        hotVc.menuViewStyle = WMMenuViewStyleLine;
//        hotVc.progressWidth = 30;
        hotVc.itemMargin = 10;
        hotVc.progressHeight = 3;
        hotVc.automaticallyCalculatesItemWidths = YES;
        hotVc.titleFontName = @"PingFangSC-Medium";
        hotVc.titleColorNormal = CZGlobalGray;
        hotVc.titleColorSelected = [UIColor blackColor];
        hotVc.titleSizeNormal = 15.0f;
        hotVc.titleSizeSelected = 16;
        hotVc.progressColor = [UIColor redColor];
    }
    if ([vc isKindOfClass:[CZTrialMainController class]]) {
        WMPageController *hotVc = (WMPageController *)vc;
        hotVc.selectIndex = 0;
        hotVc.menuViewStyle = WMMenuViewStyleDefault;
        hotVc.itemMargin = 10;
        hotVc.automaticallyCalculatesItemWidths = YES;
        hotVc.titleFontName = @"PingFangSC-Medium";
        hotVc.titleColorNormal = CZGlobalGray;
        hotVc.titleColorSelected = [UIColor blackColor];
        hotVc.titleSizeNormal = 18;
        hotVc.titleSizeSelected = 18;
    }
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:vc];
//    [vc.navigationController setNavigationBarHidden:YES];
    [self addChildViewController:nav];
}

@end
