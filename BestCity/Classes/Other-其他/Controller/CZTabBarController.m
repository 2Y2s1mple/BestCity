//
//  CZTabBarController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTabBarController.h"

#import "CZMainViewController.h" // 主页

#import "CZRedPacketsController.h" // 百万红包
#import "CZIssueMomentsController.h" // 发圈
#import "CZMainHotSaleController.h"
#import "CZDiscoverController.h"
#import "CZEvaluationController.h" // 评测


#import "CZMeController.h"
#import "CZNavigationController.h"
//#import "CZFestivalController.h" // 活动
#import "CZLoginController.h"
// 视图
#import "CZTabbar.h"

#import "CZEInventoryEditorController.h"
#import "CZMemberOfCenterController.h" // 会员中心


@interface CZTabBarController ()<UITabBarControllerDelegate>

@end

@implementation CZTabBarController

+(void)initialize
{
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = UIColorFromRGB(0x282828);
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = CZREDCOLOR;
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
    [self createSubController:YES];
}

- (void)createSubController:(BOOL)isFestiva
{
    [self setupWithController:[[CZMainViewController alloc] init] title:@"首页" image:@"tab-main-nor" selectedImage:@"tab-main-sel"];

//    [self setupWithController:[[CZRedPacketsController alloc] init] title:@"红包" image:@"tab-red-packet-nor" selectedImage:@"tab-red-packet-sel"];

    CZEvaluationController *vc = [[CZEvaluationController alloc] init];
    vc.isTabbarPush = YES;
//    [self setupWithController:vc title:@"评测" image:@"tab-try-nor" selectedImage:@"tab-try-sel"];
    
    [self setupWithController:[[CZMemberOfCenterController alloc] init] title:@"会员" image:@"tab-members-nor" selectedImage:@"tab-members-sel"];

    [self setupWithController:[[CZIssueMomentsController alloc] init] title:@"发圈" image:@"tab-moments-nor" selectedImage:@"tab-moments-sel"];

    [self setupWithController:[[CZMeController alloc] init] title:@"我的" image:@"tab-people-nor" selectedImage:@"tab-people-sel"];

    [self setValue:[[CZTabbar alloc] init] forKey:@"tabBar"];
    self.tabBar.clipsToBounds = NO;
    self.selectedIndex = 0;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%lu", (unsigned long)tabBarController.selectedIndex);

    if (tabBarController.selectedIndex == 1) {
        [CZJIPINStatisticsTool statisticsToolWithID:@"pingce"];
    } else if (tabBarController.selectedIndex == 2) {
        [CZJIPINStatisticsTool statisticsToolWithID:@"bangdan"];
    }
    UINavigationController *nav = (UINavigationController *)viewController;
    BOOL isLogin = ([JPTOKEN length] <= 0);
    BOOL isCZMeController = [nav.topViewController isKindOfClass:[CZMeController class]];
    BOOL isCZMemberOfCenterController = [nav.topViewController isKindOfClass:[CZMemberOfCenterController class]];
    
    if (isLogin && (isCZMeController || isCZMemberOfCenterController)) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
        self.selectedIndex = 0;
    }
}

- (void)setupWithController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

@end
