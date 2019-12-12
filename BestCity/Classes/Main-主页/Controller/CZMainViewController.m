//
//  CZMainViewController.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainViewController.h"
#import "CZMainViewModel.h"

// 视图
#import "CZMainViewSearch.h"
#import "CZLabel.h"

// 子视图
#import "CZFestivalController.h"

// 跳转
#import "CZTaobaoSearchController.h"

@interface CZMainViewController ()
/** viewModel */
@property (nonatomic, strong) CZMainViewModel *viewModel;
/** 状态栏的最大坐标 */
@property (nonatomic, assign) CGFloat STATUSBAR_MAX_ORIGIN_Y;
/** 补贴方法 */
@property (nonatomic, strong)  CZLabel *remindLabel;
@end

@implementation CZMainViewController

- (CGFloat)STATUSBAR_MAX_ORIGIN_Y
{
    return (IsiPhoneX ? 44 : 20);
}

- (CZMainViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[CZMainViewModel alloc] init];
    }
    return _viewModel;
}

- (void)loadView
{
    [super loadView];
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleLine;
    //        self.progressWidth = 30;
    self.itemMargin = 21;
    self.progressHeight = 3;
    self.progressColor = UIColorFromRGB(0xFFFFFF);
    self.automaticallyCalculatesItemWidths = YES;
    self.titleFontName = @"PingFangSC-Regular";
    self.titleColorNormal = UIColorFromRGB(0xFFFFFF);
    self.titleColorSelected = UIColorFromRGB(0xFFFFFF);
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 14;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x143030);

    // h数据
    [self.viewModel getMainTitles:^{
        [self reloadData];
    }];

    // UI
    [self createUI];
}

#pragma mark - UI创建
- (void)createUI
{
    // 搜索
    CZMainViewSearch *searchView = [[CZMainViewSearch alloc] init];
    searchView.y = self.STATUSBAR_MAX_ORIGIN_Y + 4;
    [searchView setBlock:^{
        CZTaobaoSearchController *vc = [[CZTaobaoSearchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:searchView];

    // 补贴方法
    self.remindLabel = [CZLabel labelText:@"补贴方法：①复制淘宝商品标题或淘口令 ； ②搜索商品领取专属补贴" textColor:0xFFFFFF font:10 alignment:NSTextAlignmentCenter bold:NO];
    self.remindLabel.alpha = 0.6;
    self.remindLabel.y = CZGetY(searchView) + 10;
    self.remindLabel.size = CGSizeMake(SCR_WIDTH, 14);
    [self.view addSubview:self.remindLabel];

}

#pragma mark - 数据




#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewModel.mainTitles.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            CZFestivalController *vc = [[CZFestivalController alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
        case 1:
        {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
        case 2:
        {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
        case 3:
        {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
        default:
        {
            return [[UIViewController alloc] init];
        }
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.viewModel.mainTitles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, CZGetY(self.remindLabel) + 8, SCR_WIDTH, 33);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, CZGetY(self.remindLabel) + 8 + 33, SCR_WIDTH, SCR_HEIGHT - (CZGetY(self.remindLabel) + 8 + 33 + (IsiPhoneX ? 83 : 49)));
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
