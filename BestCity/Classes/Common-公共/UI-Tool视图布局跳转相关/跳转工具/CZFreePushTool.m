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
- (void)pushToVC:(NSDictionary *)param
{
    //0默认消息，
    //1榜单首页，
    //11榜单详情，
    //2评测主页
    //12商品详情，，
    //21评测文章，
    //23清单文章web，
    //24清单文章json，
    //3新品主页，
    //31新品详情，
    //4免单主页，
    //41免单详情,
    //5免单
    NSInteger targetType  = [param[@"targetType"] integerValue];
    NSString *targetId = param[@"targetId"];
    NSString *targetTitle = param[@"targetTitle"];


   // 轮播图跳转类型：0不跳转, 2评测详情，11.专题页面 12.淘宝客详情页面, 13.H5页面，14.极币商城，15.任务中心，16.免单主页，17.榜单主页

//    switch (targetType) {
//        case 2: // 2评测详情
//        {
//            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
//            vc.detailType = CZJIPINModuleEvaluation;
//            vc.findgoodsId = targetId;
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//            break;
//        }
//        case 11: // 11.专题页面
//        {
//            break;
//        }
//        case 12: // 11.淘宝客详情页面
//        {
//            break;
//        }
//        case 13: // 13. H5页面
//        {
//            break;
//        }

//        case 11:
//        {
//            CZMainHotSaleDetailController *vc = [[CZMainHotSaleDetailController alloc] init];
//            vc.ID = targetId;
//            vc.titleText = [NSString stringWithFormat:@"%@榜单", targetTitle];
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//            break;
//        }
//        case 12:
//        {
//            CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
//            vc.goodsId = targetId;
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//            break;
//        }
//
//        case 21:
//        {
//            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
//            vc.detailType = CZJIPINModuleEvaluation;
//            vc.findgoodsId = targetId;
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//            break;
//        }
//        case 23:
//        {
//            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
//            vc.detailType = CZJIPINModuleQingDan;
//            vc.findgoodsId = targetId;
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//            break;
//        }
//        case 24:
//        {
//            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
//            vc.detailType = CZJIPINModuleQingDan;
//            vc.findgoodsId = targetId;
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//            break;
//        }
//        case 3:
//        {
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            tabbar.selectedIndex = 2;
//            UINavigationController *nav = tabbar.selectedViewController;
//            WMPageController *hotVc = (WMPageController *)nav.topViewController;
//            hotVc.selectIndex = 0;
//            break;
//        }
//        case 31:
//        {
//            CZTrialDetailController *vc = [[CZTrialDetailController alloc] init];
//            vc.trialId = targetId;
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            tabbar.selectedIndex = 2;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//            break;
//        }
//        case 4:
//        {
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            tabbar.selectedIndex = 2;
//            UINavigationController *nav = tabbar.selectedViewController;
//            WMPageController *hotVc = (WMPageController *)nav.topViewController;
//            hotVc.selectIndex = 1;
//            break;
//        }
//        case 5:
//        {
//            // 记录新人邀请点击
//            didClickedNewPeople = YES;
//            if ([JPTOKEN length] <= 0) {
//                CZLoginController *vc = [CZLoginController shareLoginController];
//                UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
//                [tabbar presentViewController:vc animated:NO completion:nil];
//                return;
//            }
//
//            CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//            break;
//        }
//        case 41:
//        {
//            CZFreeChargeDetailController *vc = [[CZFreeChargeDetailController alloc] init];
//            vc.Id = targetId;
//            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            tabbar.selectedIndex = 2;
//            UINavigationController *nav = tabbar.selectedViewController;
//            [nav pushViewController:vc animated:YES];
//        }
//        default:
//            break;
//    }
}

#pragma mark - 评测详情
- (void)testDetailWithId:(NSString *)Id
{
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.detailType = CZJIPINModuleEvaluation;
    vc.findgoodsId = Id;
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 专题页面
- (void)projectPageWithId:(NSString *)Id title:(NSString *)title
{
    CZMainProjectGeneralView *vc = [[CZMainProjectGeneralView alloc] init];
    vc.titleText = title;
    vc.category2Id = Id;
    CURRENTVC(currentVc)
    [currentVc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 淘宝客详情页面
- (void)tabbaokeDetailWithId:(NSString *)Id title:(NSString *)title
{
    CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
    vc.otherGoodsId = Id;
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 通用的H5界面
- (void)generalH5WithUrl:(NSString *)url title:(NSString *)title
{
    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.titleName = title;
    CURRENTVC(currentVc)
    [currentVc.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 极币商城
- (void)pointsShop
{
    CZMyPointsController *vc = [[CZMyPointsController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 任务中心
- (void)taskCenter
{
    CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 老人免单主页
- (void)oldFree
{
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 3;
}

#pragma mark - 新人免单主页
- (void)newPeopleFree
{
    CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];

}

#pragma mark - 榜单主页
- (void)aaaa
{
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 1;
}

@end
