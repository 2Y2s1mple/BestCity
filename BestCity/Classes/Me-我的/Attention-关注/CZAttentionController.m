//
//  CZAttentionController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionController.h"
#import "CZNavigationView.h"
#import "CZAttentionCell.h"
#import "CZAttentionDetailController.h"
#import "CZAttentionsModel.h"
#import "MJRefresh.h"
#import "GXNetTool.h"
#import "MJExtension.h"

@interface CZAttentionController ()<UITableViewDelegate, UITableViewDataSource, CZAttentionCellDelegate>
/** 关注列表 */
@property (nonatomic, strong) NSMutableArray *attentionsData;
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZAttentionController
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noAttentionView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}
/** 关注数据 */
- (NSMutableArray *)attentionsData
{
    if (_attentionsData == nil) {
        _attentionsData = [NSMutableArray array];
    }
    return _attentionsData;
}

// 初始化tableView
- (void)setupTableView
{
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我的关注" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CZGetY(navigationView) + 1, SCR_WIDTH, SCR_HEIGHT - CZGetY(navigationView) - 68) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载表格
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefresh];
}

/** 加载刷新控件*/
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNowAttentions)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAttentions)];
}

// 刷新
- (void)loadNowAttentions
{
    // 结束footer
    [self.tableView.mj_footer endRefreshing];
    
    // 加载数据
    self.page = 0;
    
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    param[@"page"] = @(self.page);
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/selectAll"];
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"])
        {
            if ([result[@"list"] count] > 0) {
                // 删除nodata
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
            // 字典转模型
            self.attentionsData = [CZAttentionsModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.tableView reloadData];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

// 加载更多
- (void)loadMoreAttentions
{
    self.page++;
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    param[@"page"] = @(self.page);
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/selectAll"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"list"] count] != 0)
        {
            // 字典转模型
            NSArray *attentions = [CZAttentionsModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.attentionsData addObjectsFromArray:attentions];
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        } else {
            // 显示没有更多数据
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attentionsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZAttentionsModel *model = self.attentionsData[indexPath.row];
    CZAttentionCell *cell = [CZAttentionCell cellWithTabelView:tableView];
    cell.delegate = self;
    cell.title = [NSString stringWithFormat:@"第%ld个", (long)indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZAttentionsModel *model = self.attentionsData[indexPath.row];
    CZAttentionDetailController *vc = [[CZAttentionDetailController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <CZAttentionCellDelegate>刷新
- (void)reloadAttentionTableView
{
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
@end
