//
//  CZTrialSuccessReportController.m
//  BestCity
//
//  Created by JasonBourne on 2019/5/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialSuccessReportController.h"
#import "GXNetTool.h"
#import "CZTrialApplyForCell.h"
#import "CZDChoiceDetailController.h"
#import "CZChoicenessCell.h"

@interface CZTrialSuccessReportController ()<UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;

@end

@implementation CZTrialSuccessReportController
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 200;
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7) - 50 - 1) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor whiteColor];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];

    // 创建表
    [self.view addSubview:self.tableView];

    [self setupRefresh];
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/my/trial/reportList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
            }
            self.dataSource = [CZDiscoverDetailModel objectArrayWithKeyValuesArray:result[@"data"]];


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

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/my/trial/reportList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {

            NSArray *freshData = [CZDiscoverDetailModel objectArrayWithKeyValuesArray:result[@"data"]];;
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            }
            if (freshData.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.dataSource addObjectsFromArray:freshData];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {// 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
    static NSString *ID1 = @"choiceCell1";
    CZChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZChoicenessCell class]) owner:nil options:nil] lastObject];
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.detailType = CZJIPINModuleTrail;
    vc.findgoodsId = model.articleId;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
