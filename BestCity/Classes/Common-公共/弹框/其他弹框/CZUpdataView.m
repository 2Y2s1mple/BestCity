//
//  CZUpdataView.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUpdataView.h"
#import "CZCoinCenterController.h"
#import "UIImageView+WebCache.h"
#import "CZMainHotSaleDetailController.h" // 榜单
#import "CZRecommendDetailController.h" // 商品详情
#import "CZDChoiceDetailController.h" // 测评文章
#import "WMPageController.h"
#import "CZTrialDetailController.h" // 新品试用
#import "CZFreeChargeDetailController.h"




@interface CZUpdataView ()
/** 111111111 */
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
/** 1111111111 */
@property (nonatomic, weak) IBOutlet UILabel *chengeContent;
/** 删除按钮 */
@property (nonatomic, weak) IBOutlet UIButton *delectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delectBtnTopConst;
/** <#注释#> */
@property (nonatomic, strong) CZUpdataView *updataView;
@property (weak, nonatomic) IBOutlet UIImageView *buyingImage;
@end

@implementation CZUpdataView
// 面向协议
@synthesize versionMessage = _versionMessage;
- (void)setVersionMessage:(NSDictionary *)versionMessage
{
    _versionMessage = versionMessage;
    self.versionLabel.text = versionMessage[@"versionName"];
    self.chengeContent.text = versionMessage[@"content"];
    if ([versionMessage[@"needUpdate"] integerValue] == 1) {
        self.delectBtn.hidden = YES;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}



/** 抢购 */
+ (instancetype)buyingView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

- (IBAction)buyingClicked:(id)sender {
    NSLog(@"0000000000000");
    [self pushToVC:self.paramDic];
    if ([alertList_ containsObject:self]) {
        [alertList_ removeObjectAtIndex:0];
    }
    [self removeFromSuperview];
}

- (void)setParamDic:(NSDictionary *)paramDic
{
    _paramDic = paramDic;
    [self.buyingImage sd_setImageWithURL:[NSURL URLWithString:paramDic[@"img"]]];
}

/** 删除自己 */
- (IBAction)deleteView
{
    [self removeFromSuperview];
    if ([alertList_ containsObject:self]) {
        [alertList_ removeObjectAtIndex:0];
    }
}


- (void)pushToVC:(NSDictionary *)param
{
    //0默认消息，1榜单首页，11榜单详情，12商品详情，2评测主页，21评测文章，23清单文章web，24清单文章json，3新品主页，31新品详情，4免单主页，41免单详情, 5免单(新人0元购)
    NSInteger targetType  = [param[@"targetType"] integerValue];
    NSString *targetId = param[@"targetId"];
    NSString *targetTitle = param[@"targetTitle"];

    switch (targetType) {
        case 11:
        {
            CZMainHotSaleDetailController *vc = [[CZMainHotSaleDetailController alloc] init];
            vc.ID = targetId;
            vc.titleText = [NSString stringWithFormat:@"%@榜单", targetTitle];
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 12:
        {
            CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
            vc.goodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 1;
            break;
        }
        case 21:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleEvaluation;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 23:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleQingDan;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 24:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleQingDan;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            WMPageController *hotVc = (WMPageController *)nav.topViewController;
            hotVc.selectIndex = 0;
            break;
        }
        case 31:
        {
            CZTrialDetailController *vc = [[CZTrialDetailController alloc] init];
            vc.trialId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            WMPageController *hotVc = (WMPageController *)nav.topViewController;
            hotVc.selectIndex = 1;
            break;
        }
        case 5:
        {
            [CZFreePushTool push_newPeopleFree2];
            break;
        }
        case 41:
        {
            CZFreeChargeDetailController *vc = [[CZFreeChargeDetailController alloc] init];
            vc.Id = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}

@end
