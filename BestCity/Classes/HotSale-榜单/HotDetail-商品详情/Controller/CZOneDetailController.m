//
//  CZOneDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZOneDetailController.h"
#import "CZRecommendNav.h"
#import "CZCommoditySubController.h"
#import "CZTestSubController.h"
#import "CZEvaluateSubController.h"
#import "CZShareAndlikeView.h"
#import "CZShareView.h"

@interface CZOneDetailController () <CZRecommendNavDelegate>
/** 主标题数组 */
@property (nonatomic, strong) NSArray *mainTitles;


@end

@implementation CZOneDetailController

/**
 主标题数组
 */
- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"商品", @"评测", @"评价"];
    }
    return _mainTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CZGlobalWhiteBg;
    
    //自定义的导航栏
//    CZRecommendNav *nav = [[CZRecommendNav alloc] initWithFrame:CGRectMake(0, 20, SCR_WIDTH, 40)];
//    nav.delegate = self;
//    [self.view addSubview:nav];
    
    //左边按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.backgroundColor = [UIColor redColor];
    [leftBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    leftBtn.frame = CGRectMake(10, 35, 50, 20);
    [self.view addSubview:leftBtn];
    
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.backgroundColor = [UIColor redColor];
    [rightBtn setImage:[UIImage imageNamed:@"nav-favor"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    rightBtn.frame = CGRectMake(SCR_WIDTH - 40, 28, 30, 30);
    [self.view addSubview:rightBtn];
    
    
    CZShareAndlikeView *likeView = [[CZShareAndlikeView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - 55, SCR_WIDTH, 55) leftBtnAction:^{
        //        [[CZUMConfigure shareConfigure] shareToPlatformType:UMSocialPlatformType_Sina currentViewController:self];
        CZShareView *share = [[CZShareView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:share];
    } rightBtnAction:^{}];
    [self.view addSubview:likeView];
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <CZRecommendNavDelegate>
- (void)recommendNavWithPop:(UIView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[CZCommoditySubController alloc] init];
        case 1: return [[CZTestSubController alloc] init];
        case 2: return [[CZEvaluateSubController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(100, 20, SCR_WIDTH - 200, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 70, SCR_WIDTH, SCR_HEIGHT - 70 - 55);
}














@end
