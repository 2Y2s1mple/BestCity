//
//  CZEvaluationController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluationController.h"
#import "GXNetTool.h"
#import "CZDChoicenessController.h"
#import "CZDiscoverTitleModel.h"

// 子控制器
#import "CZEAttentionController.h" // 关注
#import "CZERecommendController.h" // 推荐
//#import "CZETestController.h" // 评测
#import "CZETestAllOpenBoxController.h" // 开箱
#import "CZETestAllContrastController.h" //横屏

// 视图
#import "CZEvaluationSearchView.h"
#import "GXButtons.h"

// 视图模型
#import "CZEvaluationViewModel.h"

// 跳转
#import "CZHotsaleSearchController.h"

@interface CZEvaluationController ()
/** viewModel */
@property (nonatomic, strong) CZEvaluationViewModel *viewModel;
/** 顶部搜索栏 */
@property (nonatomic, strong) CZEvaluationSearchView *searchView;

@end

@implementation CZEvaluationController
#pragma mark - viewModel
- (CZEvaluationViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[CZEvaluationViewModel alloc] init];
    }
    return _viewModel;
}


#pragma mark - 视图
- (CZEvaluationSearchView *)searchView
{
    if (_searchView == nil) {
        CZEvaluationSearchView *search = [[CZEvaluationSearchView alloc] initWithFrame:CGRectMake(50, (IsiPhoneX ? 54 : 30), SCR_WIDTH - 60, 30)];
        search.didClickedSearchView = ^{
            [self pushSearchView];
        };
        _searchView = search;
    }
    return _searchView;
}

// 跳转到搜索页面
- (void)pushSearchView
{
    NSString *text = @"首页搜索框";
    NSDictionary *context = @{@"message" : text};
    [MobClick event:@"ID1" attributes:context];
    CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 生命周期
- (void)loadView
{
    [super loadView];
    WMPageController *hotVc = (WMPageController *)self;
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
    self.selectIndex = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    if (!self.isTabbarPush) {
        GXButtons *popBtn = [GXButtons buttonWithFrame:CGRectMake(10, (IsiPhoneX ? 54 : 30), 30, 30) backImage:[UIImage imageNamed:@"小分类榜单"] bColor:[UIColor whiteColor] cornerRadius:0 eventBlock:^(UIButton * _Nonnull sender) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.view addSubview:popBtn];
    }
    // 创建视图
    [self.view addSubview:self.searchView];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewModel.titlesText.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            CZEAttentionController *vc = [[CZEAttentionController alloc] init];
            return vc;
        }
        case 1:
        {
            CZERecommendController *vc = [[CZERecommendController alloc] init];
            return vc;
        }
        case 2:
        {
            CZETestAllOpenBoxController *vc = [[CZETestAllOpenBoxController alloc] init];
            return vc;
        }
        case 3:
        {
            CZETestAllContrastController *vc = [[CZETestAllContrastController alloc] init];
            return vc;
        }
        default:
        {
            return [[UIViewController alloc] init];
        }
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.viewModel.titlesText[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, CZGetY(self.searchView) + 18, SCR_WIDTH, 26);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    if (self.isTabbarPush) {
        return CGRectMake(0, CZGetY(self.searchView) + 18 + 26 + 18, SCR_WIDTH, SCR_HEIGHT - (CZGetY(self.searchView) + 18 + 26 + 18 + (IsiPhoneX ? 34 + 49 : 49)));
    } else {
        return CGRectMake(0, CZGetY(self.searchView) + 18 + 26 + 18, SCR_WIDTH, SCR_HEIGHT - (CZGetY(self.searchView) + 18 + 26 + 18 + (IsiPhoneX ? 34 : 0)));
    }
    
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    NSString *text = [NSString stringWithFormat:@"测评--%@", info[@"title"]];
    NSDictionary *context = @{@"oneTab" : text};
    [MobClick event:@"ID3" attributes:context];
    NSLog(@"----%@", text);
    if ([info[@"title"] isEqualToString:@"关注"] || [info[@"title"] isEqualToString:@"推荐"]) {
//        [viewController performSelector:@selecto r(viewWillAppear:) withObject:nil
//                             afterDelay:0];
    }
}



//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self obtainTtitles];
//}
//
//- (void)obtainTtitles
//{
//    //获取数据
//    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/evaluation/categoryList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
//        if ([result[@"msg"] isEqualToString:@"success"]) {
//            //标题的数据
//            [CZDiscoverTitleModel objectArrayWithKeyValuesArray:result[@"data"]];
//
//            //刷新WMPage控件
//            [self reloadData];
//        }
//        //隐藏菊花
//        [CZProgressHUD hideAfterDelay:0];
//    } failure:^(NSError *error) {
//        //隐藏菊花
//        [CZProgressHUD hideAfterDelay:0];
//    }];
//}
@end
