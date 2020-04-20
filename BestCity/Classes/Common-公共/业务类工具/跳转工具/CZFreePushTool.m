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
#import "CZSubFreePreferentialController.h" // 特惠购
#import "CZMainHotSaleController.h" // 榜单
#import "CZInvitationController.h" // 邀请好友
#import "CZMemberOfCenterController.h" // 会员中心
#import "CZEvaluationController.h" // 测评

@implementation CZFreePushTool
// 轮播图广告跳转
+ (void)bannerPushToVC:(NSDictionary *)param
{
    NSInteger targetType  = [param[@"targetType"] integerValue];
    NSString *targetId = param[@"targetId"];
    NSString *targetTitle = param[@"targetTitle"];

   // 轮播图跳转类型：0不跳转, 2评测详情，11.专题页面 12.淘宝客详情页面, 13.H5页面，14.极币商城，15.任务中心，16.榜单主页，17.榜单主页 18.新人0元购

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
        case 18:
            [self FreePreferential];
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
    // 1.专题页，2.淘宝客商品详情页，3.评测详情页，4.H5页面，5.极币商城，6.任务中心，7.免单主页，8.榜单主页, 9.测评

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
         case 9:
             [self push_evaluation];
             break;


         default:
             break;
     }
}

// 极品城跳转
+ (void)jumpToVC:(NSDictionary *)param
{
     NSInteger targetType  = [param[@"targetType"] integerValue];
     NSString *targetId = param[@"targetId"];
     NSString *targetTitle = param[@"targetTitle"];
    //1.专题页，2.淘宝客商品详情页，3.评测详情页，4.H5页面，5.极币商城，6.任务中心，7.免单主页，8.榜单主页

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
+ (void)push_newPeopleFree
{
    CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];

}

#pragma mark - 榜单主页
+ (void)hotSale
{
    CZMainHotSaleController *vc = [[CZMainHotSaleController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 特惠购
+ (void)FreePreferential
{
    CZSubFreePreferentialController *vc = [[CZSubFreePreferentialController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}


#pragma mark -  邀请好友
+ (void)push_inviteFriend
{
    CZInvitationController *vc = [[CZInvitationController alloc] init];
    CURRENTVC(currentVc)
    [currentVc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 会员中心
+ (void)push_memberOfCenter
{
    // 是否push进来的
//    CURRENTVC(currentVc);
//    CZMemberOfCenterController *vc = [[CZMemberOfCenterController alloc] init];
//    vc.isNavPush = YES;
//    [currentVc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 测评
+ (void)push_evaluation
{
    // 是否push进来的
    CURRENTVC(currentVc);
    CZEvaluationController *vc = [[CZEvaluationController alloc] init];
    vc.isTabbarPush = NO;
    [currentVc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 赚钱攻略
+ (void)push_freeMoney
{
    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/newZn.html"] rightBtnTitle:[UIImage imageNamed:@"Forward"] actionblock:^{
        NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
        shareDic[@"shareTitle"] = @"如何查找淘宝隐藏优惠券及下单返利？";
        shareDic[@"shareContent"] = @"淘宝天猫90%的商品都能省，同时还有高额返利，淘好物，更省钱！";
        shareDic[@"shareUrl"] = @"https://www.jipincheng.cn/newZn.html";
        shareDic[@"shareImg"] = [UIImage imageNamed:@"MemberOfCenter-16"];
        [CZJIPINSynthesisTool JIPIN_UMShareUI2_Web:shareDic];
    }];
    vc.titleName = @"极品城省钱攻略";
    CURRENTVC(currentVc);
    [currentVc.navigationController pushViewController:vc animated:YES];
}


@end
