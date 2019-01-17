//
//  CZMainAttentionController.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainAttentionController.h"
#import "CZNavigationView.h"
#import "CZAttentionController.h"

@interface CZMainAttentionController ()
@property (nonatomic, strong) NSArray *mainTitles;
@end

@implementation CZMainAttentionController

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
    
    UIImage *image = [UIImage imageNamed:@"nav-back"] ;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn setImage:image forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(20, (IsiPhoneX ? 44 : 20), 80, 47);
    leftBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20) + 50, SCR_WIDTH, 0.7)];
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
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            CZAttentionController *vc = [[CZAttentionController alloc] init];
            vc.type = @"1";
            return vc;   
        }
        case 1: return [[CZAttentionController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(100, (IsiPhoneX ? 44 : 20), SCR_WIDTH - 200, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, (IsiPhoneX ? 44 : 20) + 50.7, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + 50.7));
}

@end
