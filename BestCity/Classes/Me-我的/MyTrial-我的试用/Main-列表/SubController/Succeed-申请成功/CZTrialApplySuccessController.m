//
//  CZTrialApplySuccessController.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialApplySuccessController.h"
#import "GXNetTool.h"
#import "CZTrialApplySuccessCell.h"
#import "CZTrialApplySuccessModel.h"
#import "CZTrialDetailController.h"
#import "CZReportEditorController.h" // 编辑器

@interface CZTrialApplySuccessController () <UITableViewDelegate, UITableViewDataSource>
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZTrialApplySuccessController
#pragma mark - 视图
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 200;
    }
    return _noDataView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7) - 50 - 1) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [CZTrialApplySuccessModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 }; 
    }];
    
    self.view.backgroundColor = [UIColor redColor];
    
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

#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"status"] = @(1);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/my/trial/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
            }
            self.dataSource = [CZTrialApplySuccessModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    param[@"status"] = @(1);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/my/trial/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            }
            if ([result[@"data"] count] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                NSArray *freshData = [CZTrialApplySuccessModel objectArrayWithKeyValuesArray:result[@"data"]];
                [self.dataSource addObjectsFromArray:freshData];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }  else {
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrialApplySuccessModel *dic = self.dataSource[indexPath.row];
    return dic.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrialApplySuccessModel *dic = self.dataSource[indexPath.row];
    CZTrialApplySuccessCell *cell = [CZTrialApplySuccessCell cellWithTableView:tableView];
    cell.block = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    cell.gotoEditorBlock = ^(NSString *ID){
        CZReportEditorController *vc = [[CZReportEditorController alloc] init];
        vc.trialId = ID;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.dicData = dic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrialDetailController *vc = [[CZTrialDetailController alloc] init];
    CZTrialApplySuccessModel *dic = self.dataSource[indexPath.row];
    vc.trialId = dic.ID;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
