//
//  CZMainProjectGeneralView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainProjectGeneralView.h"
#import "CZNavigationView.h"
#import "CZTitlesViewTypeLayout.h"
// 工具
#import "GXNetTool.h"

#import "CZCollectionTypeOneCell.h" // 一行
#import "CZguessWhatYouLikeCell.h" // 横排

// 跳转
#import "CZTaobaoDetailController.h"

@interface CZMainProjectGeneralView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectView;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *asc; // (1正序，0倒序);
@property (nonatomic, strong) NSString *orderByType;  // 0综合，1价格，2返现，3销量
/** 是否是条形布局 */
@property (nonatomic, assign) BOOL layoutType;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZMainProjectGeneralView
#pragma mark - 系统的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 数据初始化
    self.asc = @"1"; // (1正序，0倒序);
    self.orderByType = @"0";
    self.layoutType = YES;

    // 创建UI
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.titleText rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];

    CZTitlesViewTypeLayout *titleView = [[CZTitlesViewTypeLayout alloc] init];
    [self.view addSubview:titleView];
    titleView.y = CZGetY(navigationView);
    titleView.width = SCR_WIDTH;
    titleView.height = 38;
    [titleView setBlcok:^(BOOL isLine, BOOL isAsc, NSInteger index) {
        [self.collectView setContentOffset:CGPointZero];
        if (self.layoutType != isLine) {
            self.layoutType = isLine;
            [self.collectView reloadData];
        } else {
            // (1正序，0倒序);
            self.asc =  [NSString stringWithFormat:@"%@", @(isAsc)];
            // orderByType : 0综合，1价格，2返现，3销量
            self.orderByType = [NSString stringWithFormat:@"%@", @(index)];
            [self reloadNewTrailDataSorce];
        }
    }];

    UIView *line = [[UIView alloc] init];
    line.width = SCR_WIDTH;
    line.height = 10;
    line.y = CZGetY(titleView);
    line.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.view addSubview:line];

    [self.view addSubview:self.collectView];
    self.collectView.y = CZGetY(line);
    self.collectView.height = SCR_HEIGHT - self.collectView.y;
    
    [self setupRefresh];

}

#pragma mark - UI创建
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}

- (UICollectionView *)collectView
{
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
//        layout.minimumLineSpacing = 0;
        CGRect frame = CGRectMake(0, 0, SCR_WIDTH, 0);
        _collectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectView.backgroundColor = [UIColor clearColor];
         [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([CZCollectionTypeOneCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZCollectionTypeOneCell"]; // 一行
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([CZguessWhatYouLikeCell class]) bundle:nil] forCellWithReuseIdentifier:@"CZguessWhatYouLikeCell"]; // 两行
        _collectView.dataSource = self;
        _collectView.delegate = self;
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
    NSString *api;
    if (_isGeneralProject) { // 通用专题接口
        api = @"api/tbk/getGoodsListBySubjectId";
    } else {
        api = @"api/tbk/getGoodsListByCategory2";
    }

    // 结束尾部刷新
    self.page = 1;
    [self.collectView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"subjectId"] = self.category2Id;
    param[@"category2Id"] = self.category2Id;
    param[@"orderByType"] = self.orderByType; // 0综合，1价格，2返现，3销量
    param[@"page"] = @(self.page);
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:api] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list = result[@"data"];
            if (list.count > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
                self.dataSource = [NSMutableArray arrayWithArray:list];
                // 创建头部视图
                [self.collectView reloadData];
            } else {
                // 没有数据图片
                [self.collectView addSubview:self.noDataView];
            }
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
    NSString *api;
    if (_isGeneralProject) { // 通用专题接口
        api = @"api/tbk/getGoodsListBySubjectId";
    } else {
        api = @"api/tbk/getGoodsListByCategory2";
    }
    // 结束尾部刷新
    self.page++;
    [self.collectView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"category2Id"] = self.category2Id;
    param[@"subjectId"] = self.category2Id;
    param[@"asc"] = self.asc; // (1正序，0倒序);
    param[@"orderByType"] = self.orderByType; // 0综合，1价格，2返现，3销量
    param[@"page"] = @(self.page);

    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:api] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *list = result[@"data"];
            if (list.count == 0) {
                [self.collectView.mj_footer endRefreshingWithNoMoreData];
            } else {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
                [self.dataSource addObjectsFromArray:list];
                [self.collectView reloadData];
                // 结束刷新
                [self.collectView.mj_footer endRefreshing];
            }
        } else {
            // 结束刷新
            [self.collectView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        // 结束刷新
        [self.collectView.mj_footer endRefreshing];
    }];
}


// <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

        NSDictionary *dic = self.dataSource[indexPath.item];
        if (self.layoutType == YES) { // 一条
            CZCollectionTypeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZCollectionTypeOneCell" forIndexPath:indexPath];
            cell.dataDic = dic;
            return cell;
        } else { // 块
            CZguessWhatYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZguessWhatYouLikeCell" forIndexPath:indexPath];
            cell.dataDic = dic;
            return cell;
        }
}

// <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.layoutType == YES) { // 一条
        return CGSizeMake(SCR_WIDTH, 150);
    } else { // 块
        return CGSizeMake((SCR_WIDTH - 40) / 2.0, 312);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   if (self.layoutType == YES) { // 一条
        return UIEdgeInsetsZero;
    } else { // 块
        if (self.dataSource.count == 0) {
            return UIEdgeInsetsZero;
        } else {
            return UIEdgeInsetsMake(10, 15, 10, 15);
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.layoutType == YES) { // 一条
        return 0;
    } else { // 块
        return 10;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
    NSDictionary *param = self.dataSource[indexPath.row];
    NSDictionary *bannerParam = @{
        @"targetType" : @"12",
        @"targetId" : param[@"otherGoodsId"],
        @"targetTitle" : @"",
        @"source" : [NSString stringWithFormat:@"%@", param[@"source"]],
    };
    [CZFreePushTool bannerPushToVC:bannerParam];
}

@end
