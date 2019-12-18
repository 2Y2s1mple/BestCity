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

// 数据
#import "CZMainViewSubOneVCModel.h"

@interface CZMainViewSubOneVC ()
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectView;
/** <#注释#> */
@property (nonatomic, strong) CZFestivalCollectDelegate *collectDataSurce;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *asc; // (1正序，0倒序);
@property (nonatomic, strong) NSString *orderByType;  // 0综合，1价格，2补贴，3销量
/** 是否是条形布局 */
@property (nonatomic, assign) BOOL layoutType;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *icon;

/** 总数据 */
@property (nonatomic, strong) CZMainViewSubOneVCModel *totalDataModel;

/** 精选推荐 */
@property (nonatomic, strong) NSMutableArray *qualityGoods;
@end

@implementation CZMainViewSubOneVC
#pragma mark - 系统生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // 数据初始化
    self.asc = @"1"; // (1正序，0倒序);
    self.orderByType = @"0";
    self.layoutType = YES;

    // 创建UI
    self.icon = [[UIImageView alloc] init];
    self.icon.image = [UIImage imageNamed:@"Main-矩形"];
    [self.icon setTintColor:UIColorFromRGB(0x143030)];
    self.icon.width = SCR_WIDTH;
    self.icon.height = 58;
    [self.view addSubview:self.icon];

    [self.view addSubview:self.collectView];

    // 改变上部环形图片的颜色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageColorChange:) name:@"mainImageColorChange" object:nil];
    // 监听按钮的点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsRecommendedBtnsAction:) name:@"mainSameTitleAction" object:nil];

    // 数据
    [self setupRefresh];
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
        layout.minimumInteritemSpacing = 0;
//        layout.minimumLineSpacing = 0;

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
// 精品推荐数据
- (NSMutableArray *)qualityGoods
{
    if (_qualityGoods == nil) {
        _qualityGoods = [NSMutableArray array];
    }
    return _qualityGoods;
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
       [self.collectView.mj_footer endRefreshing];
       NSMutableDictionary *param = [NSMutableDictionary dictionary];

       //获取详情数据
       [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/index"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
           if ([result[@"msg"] isEqualToString:@"success"]) {
               self.totalDataModel = [CZMainViewSubOneVCModel objectWithKeyValues:result[@"data"]];
               self.collectDataSurce.totalDataModel = self.totalDataModel;
               // 获取精品推荐
               [self getProductsRecommendedData:@{@"orderByType" : self.orderByType, @"asc" : self.asc}];
           } else {
               // 结束刷新
               [self.collectView.mj_header endRefreshing];
           }
       } failure:^(NSError *error) {// 结束刷新
           [self.collectView.mj_header endRefreshing];
       }];
}

- (void)loadMoreTrailDataSorce
{
    [self.collectView.mj_header endRefreshing];
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"orderByType"] = self.orderByType; // 0综合，1价格，2补贴，3销量
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/commendGoodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] != 0) {
                [self.qualityGoods addObjectsFromArray:result[@"data"]];
                self.collectDataSurce.qualityGoods = self.qualityGoods;
                [self.collectView reloadData];
                // 结束刷新
                [self.collectView.mj_footer endRefreshing];
            } else {
                [self.collectView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            // 结束刷新
            [self.collectView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {// 结束刷新
        [self.collectView.mj_footer endRefreshing];

    }];
}

// 获取精品推荐
- (void)getProductsRecommendedData:(NSDictionary *)dataParam
{
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"asc"] = dataParam[@"asc"]; // (1正序，0倒序);
    param[@"orderByType"] = dataParam[@"orderByType"]; // 0综合，1价格，2补贴，3销量
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/commendGoodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.qualityGoods = [NSMutableArray arrayWithArray:result[@"data"]];
            self.collectDataSurce.qualityGoods = self.qualityGoods;


            [self.collectView reloadData];
        }
        // 结束刷新
        [self.collectView.mj_header endRefreshing];

    } failure:^(NSError *error) {// 结束刷新
        [self.collectView.mj_header endRefreshing];

    }];
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

// 精品推荐的按钮
- (void)productsRecommendedBtnsAction:(NSNotification *)sender
{
    NSDictionary *param = sender.userInfo;

    if (self.layoutType != [param[@"layoutType"] boolValue]) {
        self.layoutType = [param[@"layoutType"] boolValue];
        self.collectDataSurce.layoutType = self.layoutType;
        [self.collectView reloadData];
    } else {
        self.asc =  param[@"asc"]; // (1正序，0倒序);
        self.orderByType = param[@"orderByType"];
        [self getProductsRecommendedData:param];
    }
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
