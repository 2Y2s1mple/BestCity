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
#import "CZRemindLoginView.h"
#import "CZJIPINSynthesisTool.h"
#import "CZGuideTool.h" // 新人弹框

// 子视图
#import "CZMainViewSubOneVC.h"
#import "CZGuessWhatYouLikeSubVC.h"
#import "CZMainViewSubDefaultVC.h" // 通用界面

// 跳转
#import "CZTaobaoSearchController.h"

@interface CZMainViewController ()
/** viewModel */
@property (nonatomic, strong) CZMainViewModel *viewModel;
/** 状态栏的最大坐标 */
@property (nonatomic, assign) CGFloat STATUSBAR_MAX_ORIGIN_Y;
/** 返现方法 */
@property (nonatomic, strong)  CZLabel *remindLabel;
/** 提示登录按钮 */
@property (nonatomic, strong) CZRemindLoginView *remindView;
/** 百万红包瓜分 */
@property (nonatomic, weak) UIButton *redPacketsBtn;
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

    // 数据
    [self.viewModel getMainTitles:^{
        [self reloadData];
    }];

    // UI
    [self createUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageColorChange:) name:@"mainImageColorChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remindLabelHidden) name:@"CZMainViewControllerHidden" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remindLabelShow) name:@"CZMainViewControllerShow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchAlert) name:@"showSearchAlert" object:nil];

    NSString *lastVersion = [CZSaveTool objectForKey:@"CZRemindLoginView"];
    CGFloat height = (IsiPhoneX ? 83 : 49) + 40;
    if (!lastVersion) {
        [CZSaveTool setObject:@"" forKey:@"CZRemindLoginView"];
        self.remindView = [CZRemindLoginView remindLoginView];
        self.remindView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.remindView.height = 40;
        self.remindView.width = SCR_WIDTH;
        self.remindView.y = SCR_HEIGHT - height;
        [[UIApplication sharedApplication].keyWindow addSubview:self.remindView];
    } else {
        self.remindView = [CZRemindLoginView remindLoginView2];
        self.remindView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.remindView.height = 40;
        self.remindView.width = SCR_WIDTH;
        self.remindView.y = SCR_HEIGHT - height;
        [[UIApplication sharedApplication].keyWindow addSubview:self.remindView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([JPTOKEN length] <= 0) {
        self.remindView.hidden = NO;
    } else {
        self.remindView.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.remindView.hidden = YES;
    // 百万红包
    self.redPacketsBtn.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CZJIPINSynthesisTool pasteboardAlertViewRule];
    // 百万红包
    self.redPacketsBtn.hidden = NO;
}

#pragma mark - UI创建
- (void)createUI
{
    // 搜索
    CZMainViewSearch *searchView = [[CZMainViewSearch alloc] init];
    searchView.y = self.STATUSBAR_MAX_ORIGIN_Y + 4;
    [searchView setBlock:^{
        [CZJIPINStatisticsTool statisticsToolWithID:@"shouye_sousuo"];
        CZTaobaoSearchController *vc = [[CZTaobaoSearchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:searchView];

    // 返现方法
    self.remindLabel = [CZLabel labelText:@"返现方法：①复制淘宝商品标题或淘口令 ； ②搜索商品领取专属返现" textColor:0xFFFFFF font:10 alignment:NSTextAlignmentCenter bold:NO];
    self.remindLabel.alpha = 0.6;
    self.remindLabel.y = CZGetY(searchView) + 10;
    self.remindLabel.size = CGSizeMake(SCR_WIDTH, 14);
    [self.view addSubview:self.remindLabel];


    UIButton *redPacketsBtn = [[UIButton alloc] init];
    redPacketsBtn.x = SCR_WIDTH - 140;
    redPacketsBtn.y = SCR_HEIGHT - 202 - 77;
    redPacketsBtn.size = CGSizeMake(140, 77);
    [redPacketsBtn setBackgroundImage:[UIImage imageNamed:@"redPackets-honn"] forState:UIControlStateNormal];
    [redPacketsBtn addTarget:self action:@selector(gotoRedPacketsBtn) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:redPacketsBtn];
    self.redPacketsBtn = redPacketsBtn;

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
            CZMainViewSubOneVC *vc = [[CZMainViewSubOneVC alloc] init];
            return vc;
        }
        case 1:
        {
            CZGuessWhatYouLikeSubVC *vc = [[CZGuessWhatYouLikeSubVC alloc] init];
            vc.view.backgroundColor = RANDOMCOLOR;
            return vc;
        }
        default:
        {
            CZMainViewSubDefaultVC *vc = [[CZMainViewSubDefaultVC alloc] init];
            vc.category1Id = self.viewModel.mainTitles[index][@"categoryId"];
            NSString *statistics = [NSString stringWithFormat:@"shouye_fenlei.%ld", (index + 1)];
            vc.statistics = statistics;
            return vc;
        }
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.viewModel.mainTitles[index][@"categoryName"];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, CZGetY(self.remindLabel) + 4, SCR_WIDTH, 33);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, CZGetY(self.remindLabel) + 8 + 33, SCR_WIDTH, SCR_HEIGHT - (CZGetY(self.remindLabel) + 8 + 33 + (IsiPhoneX ? 83 : 49)) + 14);
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info
{
    [CZJIPINStatisticsTool statisticsToolWithID:[NSString stringWithFormat:@"shouye_fenlei.%d", (self.selectIndex + 1)]];
    NSString *text = [NSString stringWithFormat:@"测评--%@", info[@"title"]];
    NSDictionary *context = @{@"oneTab" : text};
    [MobClick event:@"ID3" attributes:context];
    NSLog(@"----%@", text);
    if ([info[@"title"] isEqualToString:@"关注"] || [info[@"title"] isEqualToString:@"推荐"]) {
    }
    if (![info[@"title"] isEqualToString:@"精选"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shopScrollAd" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"starScrollAd" object:nil];
    }
}

#pragma mark - 事件
// 跳转百万红包
- (void)gotoRedPacketsBtn
{
    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 2;
}

// 改变颜色
- (void)imageColorChange:(NSNotification *)sender
{
    UIColor *color = sender.userInfo[@"color"];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = color;
    }];
}

// 隐藏最上面的label
- (void)remindLabelHidden
{
    if (!self.remindLabel.hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.remindLabel.hidden = YES;
            self.remindLabel.height = 0;
            self.menuView.y -= 14;
            self.scrollView.y -= 14;
        }];
    }

}

// 显示最上面的label
- (void)remindLabelShow
{
    if (self.remindLabel.hidden == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            self.remindLabel.hidden = NO;
            self.remindLabel.height = 14;
            self.menuView.y += 14;
            self.scrollView.y += 14;
        }];
    }
}


// 复制弹出搜索弹框
- (void)showSearchAlert
{
    [CZJIPINSynthesisTool pasteboardAlertViewRule];
}


@end
