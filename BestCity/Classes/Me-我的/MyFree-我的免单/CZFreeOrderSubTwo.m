//
//  CZAllOrderSubOne.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeOrderSubTwo.h"
#import "CZFreeOrderCell.h"
#import "GXNetTool.h"

@interface CZFreeOrderSubTwo () <UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CZFreeOrderSubTwo

- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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

- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDiscover)];
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

#pragma mark - 加载第一页
- (void)reloadNewDiscover
{//   申请状态：，0未付款，1待返现，3已完成 -1失效
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"applyStatus"] = @(1);

    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/user/freeList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
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
    //   申请状态：，0未付款，1待返现，3已完成 -1失效
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"applyStatus"] = @(1);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/user/freeList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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
    return 170;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.dataSource[indexPath.row];
    CZFreeOrderCell *cell = [CZFreeOrderCell cellwithTableView:tableView];
    cell.model = model;
    cell.statusLabel.text = @"待确认";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.dataSource[indexPath.row];
//    CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
//    vc.goodsId = model[@"goodsId"];
//    [self.navigationController pushViewController:vc animated:YES];
}


@end

