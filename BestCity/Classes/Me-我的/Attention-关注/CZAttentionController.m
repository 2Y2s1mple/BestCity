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
#import "GXNetTool.h"
#import "CZProgressHUD.h"
#import "MJExtension.h"
#import "CZAttentionsModel.h"
#import "MJRefresh.h"

@interface CZAttentionController ()<UITableViewDelegate, UITableViewDataSource>
/** 关注列表 */
@property (nonatomic, strong) NSMutableArray *attentionsData;
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation CZAttentionController

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
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"我的关注" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCR_WIDTH, SCR_HEIGHT - 68) style:UITableViewStylePlain];
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
    // 进来先刷一次
    [self.tableView.mj_header beginRefreshing];
    
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
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/concer"];
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"])
        {
            // 字典转模型
            self.attentionsData = [CZAttentionsModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.tableView reloadData];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:2];
            
            UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 67, SCR_WIDTH, SCR_HEIGHT - 67)];
            noDataView.backgroundColor = [UIColor redColor];
            [self.view addSubview:noDataView];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        [CZProgressHUD showProgressHUDWithText:@"网络错误!"];
        [CZProgressHUD hideAfterDelay:2];
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
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/concer"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"])
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
    cell.title = [NSString stringWithFormat:@"第%ld个", indexPath.row];
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
    CZAttentionDetailController *vc = [[CZAttentionDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
