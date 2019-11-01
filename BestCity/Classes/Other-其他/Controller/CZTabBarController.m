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
#import "CZFreeChargeController.h"
#import "CZMeController.h"
#import "CZNavigationController.h"
#import "CZFestivalController.h"// 活动
#import "CZLoginController.h"
// 视图
#import "CZTabbar.h"




#import "CZEInventoryEditorController.h"


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
}

- (void)setIsFestival:(BOOL)isFestival
{
    _isFestival = isFestival;
    [self setupWithController:[[CZMainHotSaleController alloc] init] title:@"榜单" image:@"tab-upstage-nor" selectedImage:@"tab-upstage-sel"];
    [self setupWithController:[[CZEvaluationController alloc] init] title:@"评测" image:@"tab-edit-nor" selectedImage:@"tab-edit-sel"];

    if (self.isFestival) {
        CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:[[CZFestivalController alloc] init]];
        [self addChildViewController:nav];
    }

    [self setupWithController:[[CZFreeChargeController alloc] init] title:@"免单" image:@"tab-try-nor" selectedImage:@"tab-try-sel"];
    [self setupWithController:[[CZMeController alloc] init] title:@"我的" image:@"tab-people-nor" selectedImage:@"tab-people-sel"];


    [self setValue:[[CZTabbar alloc] init] forKey:@"tabBar"];
    self.tabBar.clipsToBounds = YES;
    self.selectedIndex = 0;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSArray *configureList = @[@"tab栏榜单", @"tab栏发现", @"tab栏评测", @"tab栏试用", @"tab栏我的"];
    NSString *ID = [NSString stringWithFormat:@"ID%ld", (tabBarController.selectedIndex + 1)];
    NSDictionary *context = configureList[tabBarController.selectedIndex];
    [MobClick event:ID attributes:@{@"Tab" : context}];

    NSLog(@"%lu", (unsigned long)tabBarController.selectedIndex);

    if (_isFestival == YES && tabBarController.selectedIndex == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedFastival" object:nil userInfo:@{@"flag" : @(YES)}];
    } if (_isFestival == YES && tabBarController.selectedIndex != 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedFastival" object:nil userInfo:@{@"flag" : @(NO)}];
    }


    if ([JPTOKEN length] <= 0 && tabBarController.selectedIndex == 3) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {}
}

- (void)setupWithController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    if (![vc isKindOfClass:[CZMeController class]] && ![vc isKindOfClass:[CZMainHotSaleController class]] && [vc isKindOfClass:[WMPageController class]]) {
        WMPageController *hotVc = (WMPageController *)vc;
        hotVc.selectIndex = 0;
        hotVc.menuViewStyle = WMMenuViewStyleDefault;
        hotVc.menuItemWidth = 40;
        NSString *margin = [NSString stringWithFormat:@"%lf", (SCR_WIDTH - 160 - 44) / 3.0];
        hotVc.itemsMargins = @[@"22", margin, margin, margin, @"22"];
        hotVc.titleFontName = @"PingFangSC-Medium";
        hotVc.titleColorNormal = CZGlobalGray;
        hotVc.titleColorSelected = [UIColor blackColor];
        hotVc.titleSizeNormal = 18;
        hotVc.titleSizeSelected = 18;
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
//    vc.modalPresentationStyle =  UIModalPresentationFullScreen;
//    [vc.navigationController setNavigationBarHidden:YES];
    [self addChildViewController:nav];
}

@end
