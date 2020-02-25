//
//  CZFreePushTool.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreePushTool.h"

#import "CZDChoiceDetailController.h" // 测评文章
#import "CZTaobaoDetailController.h" // 淘宝客详情
#import "CZMyPointsController.h" // 极币商城
#import "CZMainProjectGeneralView.h" // 专题页面
#import "CZCoinCenterController.h" // 任务中心
#import "CZSubFreeChargeController.h" // 新人免单页

@implementation CZFreePushTool
// 轮播图广告跳转
+ (void)bannerPushToVC:(NSDictionary *)param
{
    NSInteger targetType  = [param[@"targetType"] integerValue];
    NSString *targetId = param[@"targetId"];
    NSString *targetTitle = param[@"targetTitle"];

   // 轮播图跳转类型：0不跳转, 2评测详情，11.专题页面 12.淘宝客详情页面, 13.H5页面，14.极币商城，15.任务中心，16.免单主页，17.榜单主页

    switch (targetType) {
        case 2:
            [self testDetailWithId:targetId];
            break;
        case 11:
            [self  projectPageWithId:targetId title:targetTitle];
            break;
        case 12:
            [self tabbaokeDetailWithId:targetId title:targetTitle];
            break;
        case 13:
            [self generalH5WithUrl:targetId title:targetTitle];
            break;
        case 14:
            [self pointsShop];
            break;
        case 15:
            [self taskCenter];
            break;
        case 16:
            [self oldFree];
            break;
        case 17:
            [self hotSale];
            break;


        default:
            break;
    }

}

// 宫格小标题跳转
+ (void)categoryPushToVC:(NSDictionary *)param
{
    NSInteger targetType  = [param[@"targetType"] integerValue];
     NSString *targetId = param[@"targetId"];
     NSString *targetTitle = param[@"targetTitle"];
    // 1.专题页，2.淘宝客商品详情页，3.评测详情页，4.H5页面，5.极币商城，6.任务中心，7.免单主页，8.榜单主页

     switch (targetType) {
         case 3:
             [self testDetailWithId:targetId];
             break;
         case 1:
             [self  projectPageWithId:targetId title:targetTitle];
             break;
         case 2:
             [self tabbaokeDetailWithId:targetId title:targetTitle];
             break;
         case 4:
             [self generalH5WithUrl:targetId title:targetTitle];
             break;
         case 5:
             [self pointsShop];
             break;
         case 6:
             [self taskCenter];
             break;
         case 7:
             [self oldFree];
             break;
         case 8:
             [self hotSale];
             break;


         default:
             break;
     }
}

#pragma mark - 评测详情
+ (void)testDetailWithId:(NSString *)Id
{
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.detailType = CZJIPINModuleEvaluation;
    vc.findgoodsId = Id;
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 专题页面
+ (void)projectPageWithId:(NSString *)Id title:(NSString *)title
{
    CZMainProjectGeneralView *vc = [[CZMainProjectGeneralView alloc] init];
    vc.isGeneralProject = YES;
    vc.titleText = title;
    vc.category2Id = Id;
    CURRENTVC(currentVc)
    [currentVc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 淘宝客详情页面
+ (void)tabbaokeDetailWithId:(NSString *)Id title:(NSString *)title
{
    CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
    vc.otherGoodsId = Id;
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 通用的H5界面
+ (void)generalH5WithUrl:(NSString *)url title:(NSString *)title
{
    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.titleName = title;
    CURRENTVC(currentVc)
    [currentVc.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 极币商城
+ (void)pointsShop
{
    CZMyPointsController *vc = [[CZMyPointsController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 任务中心
+ (void)taskCenter
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 老人免单主页
+ (void)oldFree
{
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 2;
}

#pragma mark - 新人免单主页
+ (void)newPeopleFree
{
    CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];

}

#pragma mark - 榜单主页
+ (void)hotSale
{
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 1;
}

@end
