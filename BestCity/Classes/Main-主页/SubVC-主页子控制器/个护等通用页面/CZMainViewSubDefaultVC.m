//
//  CZMainViewSubDefaultVC.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainViewSubDefaultVC.h"
// 工具
#import "GXNetTool.h"


// 视图
#import "CZMVSDefaultVCDelegate.h"

@interface CZMainViewSubDefaultVC () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSDictionary *dataSource;
/** 广告 */
@property (nonatomic, strong) NSArray *adList;
/** 宫格 */
@property (nonatomic, strong) NSArray *categoryList;
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectView;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *asc; // (1正序，0倒序);
@property (nonatomic, strong) NSString *orderByType;  // 0综合，1价格，2补贴，3销量

@property (nonatomic, strong) CZMVSDefaultVCDelegate *collectDataSurce;
@end

@implementation CZMainViewSubDefaultVC
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.collectView];
    [self setupRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.collectView.height = self.view.height;
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
        self.collectDataSurce = [[CZMVSDefaultVCDelegate alloc] initWithCollectView:_collectView];
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
    self.page = 1;
    [self.collectView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"category1Id"] = self.category1Id;
    param[@"orderByType"] = @"1"; //self.orderByType; // 0综合，1价格，2补贴，3销量
    param[@"page"] = @(self.page);
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/getGoodsListByCategory1"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            self.adList = result[@"adList"];
            self.categoryList = result[@"categoryList"];

            
            // 创建头部视图
            // 创建头部视图

            [self.collectView reloadData];
        }
        // 结束刷新
        [self.collectView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTrailDataSorce
{
    // 结束尾部刷新
    self.page++;
    [self.collectView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"orderByType"] = self.orderByType; // 0综合，1价格，2补贴，3销量
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/getGoodsListByCategory1"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list = result[@"data"];
            if (list.count == 0) {
                [self.collectView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.collectView reloadData];
                // 结束刷新
                [self.collectView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectView.mj_footer endRefreshing];
    }];
}


@end
