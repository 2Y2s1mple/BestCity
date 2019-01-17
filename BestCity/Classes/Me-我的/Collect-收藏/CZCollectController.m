//
//  CZCollectController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCollectController.h"
#import "CZNavigationView.h"
#import "CZSubCollectOneController.h"
#import "CZSubCollectTwoController.h"


@interface CZCollectController ()

@property (nonatomic, strong) NSArray *mainTitles;

@end

@implementation CZCollectController

/**
 主标题数组
 */
- (NSArray *)mainTitles
{
    if (_mainTitles == nil) {
        _mainTitles = @[@"我的关注", @"我的粉丝"];
    }
    return _mainTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我的收藏" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
}

- (void)popAction
{
    // 隐藏菊花
    [CZProgressHUD hideAfterDelay:0];    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSArray *titles = @[@"商品", @"发现", @"评测", @"试用报告"];
    return titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0: {
            CZSubCollectOneController *vc = [[CZSubCollectOneController alloc] init];
            return vc;
        }
        case 1: {
            CZSubCollectTwoController *vc = [[CZSubCollectTwoController alloc] init];
            vc.type = CZTypeDiscover;
            return vc;
        }
        case 2: {
            CZSubCollectTwoController *vc = [[CZSubCollectTwoController alloc] init];
            vc.type = CZTypeEvaluation;
            return vc;
        }
        default:{
            CZSubCollectTwoController *vc = [[CZSubCollectTwoController alloc] init];
            vc.type = CZTypeTryout;
            return vc;
        };
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7, SCR_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7 + 50, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7) + 50);
}
@end
