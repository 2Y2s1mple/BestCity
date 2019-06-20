//
//  CZFreeChargeController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeController.h"
// 视图
#import "CZFreeChargeCell.h"
#import "CZCZFreeChargeCell2.h"

// 工具
#import "GXNetTool.h"
// 模型
#import "CZFreeChargeModel.h"

@interface CZFreeChargeController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 试用数据 */
@property (nonatomic, strong) NSMutableArray *freeChargeDatas;
@end

@implementation CZFreeChargeController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + 50 + (IsiPhoneX ? 83 : 49))) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 表
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];

    //    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/index"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.freeChargeDatas = [CZFreeChargeModel objectArrayWithKeyValuesArray:result[@"data"][@"trialList"]];
            [self.tableView reloadData];
            // 结束刷新
        }
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 代理
// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.freeChargeDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CZFreeChargeCell *cell = [CZFreeChargeCell cellWithTableView:tableView];
            cell.model = self.freeChargeDatas[indexPath.row];
        return cell;
    } else {
        CZCZFreeChargeCell2 *cell = [CZCZFreeChargeCell2 cellWithTableView:tableView];
            cell.model = self.freeChargeDatas[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZFreeChargeModel *model = self.freeChargeDatas[indexPath.row];
    return model.cellHeight + 1;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
