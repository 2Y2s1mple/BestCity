//
//  CZMHSDRecommendController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDRecommendController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZMHSDCommodityCell3.h"
#import "CZDChoiceDetailController.h"

@interface CZMHSDRecommendController ()<UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CZMHSDRecommendController
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 180;
        self.noDataView.backgroundColor = [UIColor clearColor];
    }
    return _noDataView;
}
// 导航条
- ( CZNavigationView * (^)(void))createNavView
{
    return ^ {
        CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.titleText rightBtnTitle:nil rightBtnAction:nil ];
        [self.view addSubview:navigationView];
        return navigationView;
    };
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 67 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, SCR_HEIGHT - 67 - (IsiPhoneX ? 24 : 0)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航条
    [self.view addSubview:self.createNavView()];
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
    param[@"goodsCategoryId"] = self.ID;
    param[@"page"] = @(self.page);
    param[@"type"] = @(2);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {

            self.dataSource = [NSMutableArray arrayWithArray:result[@"data"]];

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
    param[@"goodsCategoryId"] = self.ID;
    param[@"page"] = @(self.page);
    param[@"type"] = @(2);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *arr = result[@"data"];
            [self.dataSource addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
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
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMHSDCommodityCell3 *cell = [CZMHSDCommodityCell3 cellwithTableView:tableView];
    cell.dataDic = self.dataSource[indexPath.row];
    cell.isFirstOne = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        NSDictionary *model = self.dataSource[indexPath.row];
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = CZJIPINModuleEvaluation;
        vc.findgoodsId = model[@"articleId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
