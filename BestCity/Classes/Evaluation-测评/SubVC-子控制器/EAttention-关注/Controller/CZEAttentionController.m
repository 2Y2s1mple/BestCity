//
//  CZEAttentionController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEAttentionController.h"
#import "CZEAttentionViewModel.h"
#import "CZEAttentionItemViewModel.h"

// 视图
#import "CZEAttentionCommendCell.h"
#import "CZEAttentionArticleCell.h"

// 跳转
#import "CZDChoiceDetailController.h"

@interface CZEAttentionController () <UITableViewDelegate, UITableViewDataSource>
/** tabelview */
@property (nonatomic, strong) UITableView *tableView;
/** viewModel */
@property (nonatomic, strong) CZEAttentionViewModel *viewModel;

@end

@implementation CZEAttentionController
#pragma mark - viewModel
- (CZEAttentionViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[CZEAttentionViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - 视图
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, ((IsiPhoneX ? 54 : 30) + 84 + (IsiPhoneX ? 83 : 49))) style:UITableViewStylePlain];
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSorce)];
}

#pragma mark - 周期
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

#pragma mark -- 方法
// UITableViewDataSource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZEAttentionItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
    if ([viewModel.model.type isEqual: @"2"]) {
        CZEAttentionCommendCell *cell = [CZEAttentionCommendCell cellwithTableView:tableView];
        [cell bindViewModel:viewModel];
        return cell;
    } else {
        CZEAttentionArticleCell *cell = [CZEAttentionArticleCell cellwithTableView:tableView];
        [cell bindViewModel:viewModel];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZEAttentionItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
    if ([viewModel.model.type isEqual: @"2"]) {
        return 427;
    } else {
        return viewModel.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
    CZEAttentionItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
    if ([viewModel.model.type isEqual: @"2"]) {
      
    } else {
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = [CZJIPINSynthesisTool getModuleType:[viewModel.model.article[@"type"] integerValue]];
        vc.findgoodsId = viewModel.model.article[@"articleId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 刷新控件
- (void)reloadNewDataSorce
{
    NSLog(@"%s", __func__);
    [self.tableView.mj_footer endRefreshing];
    [self.viewModel reloadNewDataSorce:^ {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreDataSorce
{
    NSLog(@"%s", __func__);
    [self.tableView.mj_header endRefreshing];
    [self.viewModel loadMoreDataSorce:^ {
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
