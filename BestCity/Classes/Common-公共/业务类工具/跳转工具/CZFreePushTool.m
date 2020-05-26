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
#import "CZSubFreeChargeController.h" // 新人0元购. 第一版免单页
#import "CZSub2FreeChargeController.h" // 新人0元购. 第二版
#import "CZSubFreePreferentialController.h" // 特惠购
#import "CZMainHotSaleController.h" // 榜单
#import "CZInvitationController.h" // 邀请好友
#import "CZMemberOfCenterController.h" // 会员中心
#import "CZEvaluationController.h" // 测评
#import "CZMainJingDongGeneralView.h" // 京东通用页
#import "CZTaobaoSearchMainController.h" // 所搜
#import "CZIssueCreate1Moments.h"

@implementation CZFreePushTool
// 轮播图广告跳转
+ (void)bannerPushToVC:(NSDictionary *)param
{
    NSInteger targetType = [param[@"targetType"] integerValue];
    NSString *targetId = param[@"targetId"];
    NSString *targetTitle = param[@"targetTitle"];
    NSString *targetSource;
    if (targetType == 12) { // 商品来源(1京东,2淘宝，4拼多多)
        targetSource = @"2";
    } else if (targetType == 25) {
        targetSource = @"1";
    } else if (targetType == 26) {
        targetSource= @"4";
    }
    
   // 轮播图跳转类型：0不跳转, 1商品详情, 2评测详情, 3发现详情, 4试用报告web, 41试用报告json, 5评测类目, 6试用商品, 7清单详情, 71清单详情json, 8双11首页, 9双11文章详情, 10双11类目, 11.专题页面 12.淘宝客详情页面, 13.H5页面，14.极币商城，15.任务中心，16.红包主页，17.榜单主页，18特惠购列表, 19 0元购列表, 20邀请页面, 21京东, 22拼多多, 23评测主页, 24新手教程, 25京东商品详情, 26拼多多商品详情
    switch (targetType) {
        case 2:
            [self testDetailWithId:targetId];
            break;
        case 11:
            [self  projectPageWithId:targetId title:targetTitle];
            break;
        case 12:
            [self push_tabbaokeDetailWithId:targetId title:targetTitle source:targetSource];
            break;
        case 13:
            [self generalH5WithUrl:targetId title:targetTitle containView:nil];
            break;
        case 14:
            [self push_pointsShop];
            break;
        case 15:
            [self push_taskCenter];
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
        case 19:
            [self push_newPeopleFree2];
            break;
        case 20:
            [self push_inviteFriend];
            break;
        case 21:
            [self push_jingDongGeneralView:1];// (1京东 2淘宝 4拼多多)
            break;
        case 22:
            [self push_jingDongGeneralView:4];
            break;
        case 23:
            [self push_evaluation];
            break;
        case 24:
            [self push_freeMoney];
            break;
        case 25:
            [self push_tabbaokeDetailWithId:targetId title:targetTitle source:targetSource];
            break;
        case 26:
            [self push_tabbaokeDetailWithId:targetId title:targetTitle source:targetSource];
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
    
    NSString *targetSource;
    if (targetType == 2) { // 商品来源(1京东,2淘宝，4拼多多)
        targetSource = @"2";
    }
    //跳转类型1.专题页，2.淘宝客商品详情页，3.评测详情页，4.H5页面，5.极币商城，6.任务中心，7.免单主页，8.榜单主页 9.评测首页,10特惠购列表,11 0元购列表 12京东 13拼多多,14新手教程,15邀请页面
    
     switch (targetType) {
         case 1:
             [self  projectPageWithId:targetId title:targetTitle];
             break;
         case 2:
             [self push_tabbaokeDetailWithId:targetId title:targetTitle source:targetSource];
             break;
         case 3:
             [self testDetailWithId:targetId];
             break;
         case 4:
             [self generalH5WithUrl:targetId title:targetTitle containView:nil];
             break;
         case 5:
             [self push_pointsShop];
             break;
         case 6:
             [self push_taskCenter];
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
         case 10:
             [self FreePreferential];
             break;
         case 11:
             [self push_newPeopleFree2];
             break;
         case 12:
             [self push_jingDongGeneralView:1];
             break;
         case 13:
             [self push_jingDongGeneralView:4];
             break;
         case 14:
             [self push_freeMoney];
             break;
         case 15:
             [self push_inviteFriend];
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
    NSString *targetSource = param[@"source"];
    //1.专题页，2.淘宝客商品详情页，3.评测详情页，4.H5页面，5.极币商城，6.任务中心，7.免单主页，8.榜单主页

     switch (targetType) {
         case 3:
             [self testDetailWithId:targetId];
             break;
         case 1:
             [self  projectPageWithId:targetId title:targetTitle];
             break;
         case 2:
             [self push_tabbaokeDetailWithId:targetId title:targetTitle source:targetSource];
             break;
         case 4:
             [self generalH5WithUrl:targetId title:targetTitle containView:nil];
             break;
         case 5:
             [self push_pointsShop];
             break;
         case 6:
             [self push_taskCenter];
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

#pragma mark - 淘宝, 拼多多, 京东客详情页面
+ (void)push_tabbaokeDetailWithId:(NSString *)Id title:(NSString *)title source:(NSString *)source
{
//    12.淘宝客详情页面, 25京东商品详情, 26拼多多商品详情
    CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
    vc.otherGoodsId = Id;
    vc.source = source;
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 通用的H5界面
+ (void)generalH5WithUrl:(NSString *)url title:(NSString *)title containView:(UIViewController *)containView
{
    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.titleName = title;
    if (containView) {
        [containView presentViewController:vc animated:NO completion:nil];
    } else {
        CURRENTVC(currentVc)
        [currentVc.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 极币商城
+ (void)push_pointsShop
{
    ISPUSHLOGIN;
    CZMyPointsController *vc = [[CZMyPointsController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

#pragma mark - 任务中心
+ (void)push_taskCenter
{
    ISPUSHLOGIN;
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

#pragma mark - 0元购
+ (void)push_newPeopleFree
{
    CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];

}

#pragma mark - 0元购, 第二版
+ (void)push_newPeopleFree2
{
    CZSub2FreeChargeController *vc = [[CZSub2FreeChargeController alloc] init];
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
    ISPUSHLOGIN;
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
    ISPUSHLOGIN;
    CURRENTVC(currentVc);
    // 是否push进来的
    CZMemberOfCenterController *vc = [[CZMemberOfCenterController alloc] init];
    vc.isNavPush = YES;
    [currentVc.navigationController pushViewController:vc animated:YES];
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

#pragma mark - 赚钱攻略带视频
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

#pragma mark - 京东专题
+ (void)push_jingDongGeneralView:(NSInteger)type
{
    CZMainJingDongGeneralView *vc = [[CZMainJingDongGeneralView alloc] init];
    if (type == 1) { // (1京东 2淘宝 4拼多多)
        vc.mainTitle = @"京东";
    } else {
        vc.mainTitle = @"拼多多";
    }
    vc.type = type;
    CURRENTVC(currentVc);
    [currentVc.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 搜索
+ (void)push_searchViewType:(NSInteger)source
{
    CURRENTVC(currentVc);
    CZTaobaoSearchMainController *vc = [[CZTaobaoSearchMainController alloc] init];
    vc.source = source;
    [currentVc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 创建订单
+ (void)push_createMomentsWithId:(NSString *)ID source:(NSString *)source
{
    ISPUSHLOGIN;
    CURRENTVC(currentVc);
    if ([source isEqualToString:@"2"]) { //(1京东,2淘宝，4拼多多)
        // 淘宝授权
        [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuthTaobao) {
            if (isAuthTaobao) {
                CZIssueCreateMoments *vc = [[CZIssueCreateMoments alloc] init];
                vc.otherGoodsId = ID;
                vc.source = source;
                [currentVc.navigationController pushViewController:vc animated:YES];
            }
        }];
    } else {
        CZIssueCreate1Moments *vc = [[CZIssueCreate1Moments alloc] init];
        vc.otherGoodsId = ID;
        vc.source = source;
        [currentVc.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
