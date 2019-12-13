//
//  CZMainViewSubOneVC.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainViewSubOneVC.h"
// 工具
#import "GXNetTool.h"

// 视图
#import "CZAlertTool.h"
#import <AdSupport/AdSupport.h>
#import "KCUtilMd5.h"

// 跳转
#import "CZTaobaoSearchController.h"
#import "CZGuideTool.h"

//------------------
// viewModel
#import "CZFestivalCollectDelegate.h"
@interface CZMainViewSubOneVC ()
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectView;
/** <#注释#> */
@property (nonatomic, strong) CZFestivalCollectDelegate *collectDataSurce;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *icon;
@end

@implementation CZMainViewSubOneVC
#pragma mark - 系统生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//    UIColorFromRGB(0x143030)
    self.icon = [[UIImageView alloc] init];
    self.icon.image = [UIImage imageNamed:@"Main-矩形"];
    [self.icon setTintColor:UIColorFromRGB(0x143030)];
    self.icon.width = SCR_WIDTH;
    self.icon.height = 58;
    [self.view addSubview:self.icon];

    [self.view addSubview:self.collectView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageColorChange:) name:@"mainImageColorChange" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [CZAlertTool alertRule];
    self.collectView.height = self.view.height;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 新用户指导
        [CZGuideTool newpPeopleGuide];
    });
}

#pragma mark - UI创建
- (UICollectionView *)collectView
{
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        CGRect frame = CGRectMake(0, 0, SCR_WIDTH, 0);
        _collectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor clearColor];
        self.collectDataSurce = [[CZFestivalCollectDelegate alloc] initWithCollectView:_collectView];
    }
    return _collectView;
}

// 上拉加载, 下拉刷新
- (void)setupRefresh
{
    self.collectView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.collectView.mj_header beginRefreshing];
    self.collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}


#pragma mark - 数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.collectView.mj_footer endRefreshing];
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    param[@"deviceType"] = @"IDFA";
    param[@"deviceValue"] = [KCUtilMd5 stringToMD5:idfa];
    param[@"deviceEncrypt"] = @"MD5";
    param[@"asc"] = @"1"; // (1正序，0倒序);
    param[@"keyword"] = @"电动牙刷";
    param[@"orderByType"] = @"0"; // 0综合，1价格，2补贴，3销量
    param[@"type"] = @"1"; // 分类（1搜索极品城，2搜索淘宝）
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/searchGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if (0) {
                [CZProgressHUD showProgressHUDWithText:@"极品城暂无相关推荐"];
                [CZProgressHUD hideAfterDelay:1.5];
            }
            [self.collectView reloadData];
        }
        // 结束刷新
        [self.collectView.mj_header endRefreshing];

    } failure:^(NSError *error) {// 结束刷新
        [self.collectView.mj_header endRefreshing];

    }];
}

- (void)loadMoreTrailDataSorce
{
}

#pragma mark - 事件
// 改变颜色
- (void)imageColorChange:(NSNotification *)sender
{
    UIColor *color = sender.userInfo[@"color"];
    [UIView animateWithDuration:0.25 animations:^{
        [self.icon setTintColor:color];
    }];
}

// 复制搜索弹框
- (void)showSearchAlert
{
    [CZAlertTool alertRule];
}

// 跳转搜索
- (void)pushSearchView
{
    CZTaobaoSearchController *vc = [[CZTaobaoSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
