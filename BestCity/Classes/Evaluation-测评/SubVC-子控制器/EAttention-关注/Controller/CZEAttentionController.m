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

- (UIView *)tableViewHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.height = 180;
    headerView.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"没有关注"]];
    imageView.centerX = self.tableView.centerX;
    imageView.y = 10;
    [headerView addSubview:imageView];

    UILabel *label1 = [[UILabel alloc] init];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = UIColorFromRGB(0x202020);
    label1.text = @"您还没有关注任何人";
    [label1 sizeToFit];
    label1.centerX = imageView.centerX;
    label1.y = CZGetY(imageView) + 8;
    [headerView addSubview:label1];

    UILabel *label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = @"找到你感兴趣的用户关注，每天更新的内容会出现在这里";
    label2.textColor = UIColorFromRGB(0x9D9D9D);
    label2.numberOfLines = 2;
    label2.width = 220;
    label2.height = 40;

    label2.centerX = imageView.centerX;
    label2.y = CZGetY(label1) + 5;
    [headerView addSubview:label2];


    return headerView;


}

// 上拉加载, 下拉刷新
- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSorce)];
}

#pragma mark - 周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self tableViewHeaderView];
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
        [cell setCellWithBlcok:^(NSString * _Nonnull ID, BOOL isFollow) {
                if (isFollow) {
                    for (CZEAttentionItemViewModel *viewModel in self.viewModel.dataSource) {
                        if ([viewModel.model.article[@"user"][@"userId"] isEqualToString:ID]) {
                            viewModel.isShowAttention = YES;
                        }
                    }
                } else {
                    for (CZEAttentionItemViewModel *viewModel in self.viewModel.dataSource) {
                        if ([viewModel.model.article[@"user"][@"userId"] isEqualToString:ID]) {
                            viewModel.isShowAttention = NO;
                        }
                    }
                }
                [self.tableView reloadData];
            }];
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
    [self.viewModel reloadNewDataSorce:^(NSDictionary *data) {
        if ([self.viewModel.dataSource count] > 0) {
            // 没有数据图片
            [self.noDataView removeFromSuperview];
        } else {
            // 没有数据图片
            [self.tableView addSubview:self.noDataView];
        }

        if ([data[@"count"] integerValue] > 0) {
            //隐藏菊花
            [CZProgressHUD showOrangeProgressHUDWithText:[NSString stringWithFormat:@"为您更新%@篇文章", data[@"count"]]];
        } else {
             [CZProgressHUD showOrangeProgressHUDWithText:@"刷新成功"];
        }
        [CZProgressHUD hideAfterDelay:1.5];

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

        if ([data[@"follow"] integerValue] == 0) {
            self.tableView.tableHeaderView = [self tableViewHeaderView];
        } else {
            self.tableView.tableHeaderView = nil;
        }


    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)loadMoreDataSorce
{
    NSLog(@"%s", __func__);
    [self.tableView.mj_header endRefreshing];
    [self.viewModel loadMoreDataSorce:^(NSDictionary *data) {
        if ([self.viewModel.dataSource count] > 0) {
            // 没有数据图片
            [self.noDataView removeFromSuperview];
        } else {
            // 没有数据图片
            [self.tableView addSubview:self.noDataView];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if ([data[@"follow"] integerValue] == 0) {
                   self.tableView.tableHeaderView = [self tableViewHeaderView];
               } else {
                   self.tableView.tableHeaderView = nil;
               }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}


@end
