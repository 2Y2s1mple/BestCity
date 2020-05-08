//
//  CZETestAllOpenBoxController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZETestAllOpenBoxController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZETestModel.h"
#import "CZETestOpenBoxCell.h"
#import "CZDChoiceDetailController.h"
#import "CZETestViewModel.h"

@interface CZETestAllOpenBoxController ()<UITableViewDelegate, UITableViewDataSource>
/** tabelview */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, strong) CZETestViewModel *viewModel;
@end

@implementation CZETestAllOpenBoxController

- (CZETestViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[CZETestViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.height = self.view.height - 1;
}

#pragma mark - 视图
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 24 : 0) - 67) style:UITableViewStylePlain];
        self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

// 上拉加载, 下拉刷新
- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}


#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    __weak typeof(self) weakSelf = self;
    [self.viewModel reloadNewTrailDataSorce:^(NSDictionary *data){
        [weakSelf.tableView reloadData];
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        if ([data[@"count"] integerValue] > 0) {
            //隐藏菊花
            [CZProgressHUD showOrangeProgressHUDWithText:[NSString stringWithFormat:@"为您更新%@篇文章", data[@"count"]]];
        } else {
             [CZProgressHUD showOrangeProgressHUDWithText:@"刷新成功"];
        }
        [CZProgressHUD hideAfterDelay:1.5];
    }];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    __weak typeof(self) weakSelf = self;
    [self.viewModel loadMoreTrailDataSorce:^(NSDictionary *data){
        [weakSelf.tableView reloadData];
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark -- UITableViewDataSource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.viewModel.dataSource[indexPath.row];
    CZETestOpenBoxCell *cell = [CZETestOpenBoxCell cellwithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.viewModel.dataSource[indexPath.row];
    //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.detailType = [CZJIPINSynthesisTool getModuleType:[model.type integerValue]];
    vc.findgoodsId = model.articleId;
    [self.navigationController pushViewController:vc animated:YES];
}






@end
