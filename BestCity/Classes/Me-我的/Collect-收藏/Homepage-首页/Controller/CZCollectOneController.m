//
//  CZCollectOneController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/17.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZCollectOneController.h"
#import "CZNavigationView.h"
#import "CZCollectCell.h"
#import "CZCollectionModel.h"
#import "MJExtension.h"
#import "GXNetTool.h"
#import "MJRefresh.h"
#import "CZRecommendDetailController.h" // 榜单的详情
#import "CZEvaluationChoicenessDetailController.h" // 测评详情
#import "CZDChoiceDetailController.h" // 发现详情


@interface CZCollectOneController ()<UITableViewDelegate, UITableViewDataSource>
/** 收藏数据 */
@property (nonatomic, strong) NSMutableArray *collectdsData;
/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZCollectOneController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noSelectView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}
- (NSMutableArray *)collectdsData
{
    if (_collectdsData == nil) {
        _collectdsData = [NSMutableArray array];
    }
    return _collectdsData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"收藏" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + 68, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCR_WIDTH, SCR_HEIGHT - 68) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 加载刷新控件
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //刷新
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/** 加载新数据 */
- (void)loadNewData
{
    // 结束footer刷新
    [self.tableView.mj_footer endRefreshing];
    
    // 页数
    self.page = 0;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collectAll"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 没有数据图片
            [self.noDataView removeFromSuperview];   
        } else {
            // 没有数据图片
            [self.tableView addSubview:self.noDataView];
        }
        self.collectdsData = result[@"list"];
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 加载更多数据 */
- (void)loadMoreData
{
    // 页数
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    param[@"page"] = @(self.page);
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collectAll"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {

            [self.collectdsData addObjectsFromArray:result[@"list"]];
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        } else {
            // 显示无数据
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        // 页数
        self.page--;
    }];
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.collectdsData[indexPath.row];
    switch ([dic[@"state"] integerValue]) {
        case 1: // 商品
        {
            CZCollectCell *cell = [CZCollectCell cellWithTabelView:tableView];
            cell.commodityData = dic[@"goodsRanklist"];
            return cell;
        }
        case 2: // 测评
        {
            CZCollectCell *cell = [CZCollectCell cellWithTabelView:tableView];
            cell.discoverData = dic[@"goodsEvalway"];
            return cell;
        }
        case 3: // 发现
        {
            CZCollectCell *cell = [CZCollectCell cellWithTabelView:tableView];
            cell.discoverData = dic[@"goodsFindGoods"];
            return cell;
        }
        default:
        {
            CZCollectCell *cell = [CZCollectCell cellWithTabelView:tableView];
            return cell;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectdsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.collectdsData[indexPath.row];
    switch ([dic[@"state"] integerValue]) {
        case 1: // 商品
        {
            CZRecommendListModel *model = [CZRecommendListModel objectWithKeyValues:dic[@"goodsRanklist"]];
            CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: // 测评
        {
            CZEvaluationChoicenessDetailController *vc = [[CZEvaluationChoicenessDetailController alloc] init];
            vc.detailID = dic[@"goodsEvalway"][@"evalWayId"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: // 发现
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.findgoodsId = dic[@"goodsFindGoods"][@"findgoodsId"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

@end

