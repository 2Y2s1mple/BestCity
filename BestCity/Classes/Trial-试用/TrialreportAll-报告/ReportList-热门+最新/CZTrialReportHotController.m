//
//  CZTrialReportHotController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialReportHotController.h"
// 工具
#import "GXNetTool.h"
//模型
#import "CZTrailReportModel.h"
//视图
#import "CZTrialReportMainCell.h"
// 详情
#import "CZDChoiceDetailController.h"

@interface CZTrialReportHotController ()< UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 报告数据 */
@property (nonatomic, strong) NSMutableArray *reportDatasArr;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZTrialReportHotController
#pragma mark - 懒加载
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.7, SCR_WIDTH, (SCR_HEIGHT - 68.7 - 49.7)) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"orderbyType"] = @(self.type); //（1最新，2热门）
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/reportList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([result[@"data"] count] > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
            self.reportDatasArr = [CZTrailReportModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"orderbyType"] = @(self.type); //（1最新，2热门）
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/reportList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([result[@"data"] count] > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
            NSArray *newArr = [CZTrailReportModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.reportDatasArr addObjectsFromArray:newArr];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    // 表
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];
}


// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reportDatasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrialReportMainCell *cell = [CZTrialReportMainCell cellWithTableView:tableView];
    cell.trailReportModel = self.reportDatasArr[indexPath.row];
    return cell;
}

// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        CZTrailReportModel *model = self.reportDatasArr[indexPath.row];
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = CZJIPINModuleTrail;
        vc.findgoodsId = model.articleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
