//
//  CZSearchOneSubView.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZSearchOneSubView.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"
#import "CZSearchOneSubViewCell.h"

// 跳转
#import "CZRecommendDetailController.h"
#import "CZMainHotSaleDetailController.h"

@interface CZSearchOneSubView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *collectionList;
@end

@implementation CZSearchOneSubView

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];

    // 加载刷新数据
    [self setupRefresh];
    CZTOPLINE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, SCR_WIDTH, self.view.height);
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDiscover)];
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

#pragma mark - 加载第一页
- (void)reloadNewDiscover
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"keyword"] = self.textSearch;
    param[@"type"] = @(1);

    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/search"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {

        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
            self.collectionList = result[@"goodsCategoryList"];
            if (self.collectionList.count > 0) {
                self.tableView.tableHeaderView = [self createHeaderView];
            }
            [self.collection reloadData];

            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:result[@"data"]];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 加载更多数据
- (void)loadMoreDiscover
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
//    （1商品，2清单，3问答，4评测，5试用报告）
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"keyword"] = self.textSearch;
    param[@"type"] = @(1);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/search"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"data"] count] != 0) {
            [self.dataSource addObjectsFromArray:result[@"data"]];
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataSource.count > 0) {
        UIView *view = [[UIView alloc] init];
        view.height = 45;
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x565252);
        label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
        label.text = @"商品";
        [label sizeToFit];
        label.x = 15;
        label.centerY = view.height / 2.0 + 10;
        [view addSubview:label];
        return view;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    CZSearchOneSubViewCell *cell = [CZSearchOneSubViewCell cellwithTableView:tableView];
    cell.dataDic = dic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.dataSource[indexPath.row];
    CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
    vc.goodsId = model[@"goodsId"];
    [self.navigationController pushViewController:vc animated:YES];
}

// 头视图
- (UIView *)createHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 167)];
    headerView.backgroundColor = UIColorFromRGB(0xF5F5F5);;
    [self setupProperty:headerView];
    return headerView;
}


- (void)setupProperty:(UIView *)view
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 80 + 45);
    layout.minimumLineSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, -16);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 157) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    [view addSubview:collection];

    collection.delegate = self;
    collection.dataSource = self;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CZERecommendHeaderView"];
    self.collection = collection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.collectionList[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CZERecommendHeaderView" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 6;
    cell.contentView.layer.masksToBounds = YES;

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.y = 10;
    imageView.size = CGSizeMake(80, 80);
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = UIColorFromRGB(0xE25838).CGColor;
    imageView.layer.cornerRadius = 40;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
    [cell.contentView addSubview:imageView];

    UILabel *label = [[UILabel alloc] init];
    label.y = 100;
    label.width = 80;
    label.height = 20;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x565252);
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    label.text = dic[@"categoryName"];
    [cell.contentView addSubview:label];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //类型：0不跳转，1商品详情，2发现详情 3评测详情, 4试用 5评测类目，7清单详情
    NSDictionary *model = self.collectionList[indexPath.row];
    CZMainHotSaleDetailController *vc = [[CZMainHotSaleDetailController alloc] init];
    vc.ID = model[@"categoryId"];
    vc.titleText = [NSString stringWithFormat:@"%@榜单", model[@"categoryName"]];
    [self.navigationController pushViewController:vc animated:YES];

}
@end
