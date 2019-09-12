//
//  CZERecommendController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZERecommendController.h"
// 视图模型
#import "CZERecommendViewModel.h"
#import "CZERecommendItemViewModel.h"
// 视图
#import "CZERecommendCell.h"
#import "CZERecommendHeaderView.h"
// 跳转
#import "CZDChoiceDetailController.h"

@interface CZERecommendController () <UITableViewDelegate, UITableViewDataSource>
/** tabelview */
@property (nonatomic, strong) UITableView *tableView;
/** 视图模型 */
@property (nonatomic, strong) CZERecommendViewModel *viewModel;

@end

@implementation CZERecommendController
#pragma mark - 视图模型
- (CZERecommendViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[CZERecommendViewModel alloc] init];
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

// 刷新控件
- (void)reloadNewDataSorce
{
    NSLog(@"%s", __func__);
    [self.tableView.mj_footer endRefreshing];
    [self.viewModel reloadNewDataSorce:^ {
        if ([self.viewModel.dataSource count] > 0) {
            // 没有数据图片
            [self.noDataView removeFromSuperview];
        } else {
            // 没有数据图片
            [self.tableView addSubview:self.noDataView];
        }
        if ([self.viewModel.imagesList count] > 0) {
            self.tableView.tableHeaderView = [self createHeaderView];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)loadMoreDataSorce
{
    NSLog(@"%s", __func__);
    [self.tableView.mj_header endRefreshing];
    [self.viewModel loadMoreDataSorce:^ {
        if ([self.viewModel.dataSource count] > 0) {
            // 没有数据图片
            [self.noDataView removeFromSuperview];
        } else {
            // 没有数据图片
            [self.tableView addSubview:self.noDataView];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

// 头视图
- (UIView *)createHeaderView
{
    CZERecommendHeaderView *headerView = [[CZERecommendHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 192)];
    headerView.dataList = self.viewModel.imagesList;
    return headerView;
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
    [self reloadNewDataSorce];
}

#pragma mark - 代理方法
// UITableViewDataSource代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZERecommendItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
    CZERecommendCell *cell = [CZERecommendCell cellwithTableView:tableView];
    [cell bindViewModel:viewModel];
    [cell setCellWithBlcok:^(NSString * _Nonnull ID, BOOL isFollow) {
//        [self.viewModel changeCellModelWithID:ID andIsAttention:isFollow];
        if (isFollow) {
            for (CZERecommendItemViewModel *viewModel in self.viewModel.dataSource) {
                if ([viewModel.model.user.userId isEqualToString:ID]) {
                    viewModel.model.user.follow = @"1";
                }
            }
        } else {
            for (CZERecommendItemViewModel *viewModel in self.viewModel.dataSource) {
                if ([viewModel.model.user.userId isEqualToString:ID]) {
                    viewModel.model.user.follow = @"0";
                }
            }
        }
        [self.tableView reloadData];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZERecommendItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
    return viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
    CZERecommendItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.detailType = [CZJIPINSynthesisTool getModuleType:[viewModel.model.type integerValue]];
    vc.findgoodsId = viewModel.model.articleId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
