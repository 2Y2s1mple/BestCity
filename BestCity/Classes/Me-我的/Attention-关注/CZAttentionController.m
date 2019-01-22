//
//  CZAttentionController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionController.h"
#import "CZAttentionCell.h"
#import "CZAttentionsModel.h"
#import "GXNetTool.h"
#import "CZAttentionDetailController.h"

@interface CZAttentionController ()<UITableViewDelegate, UITableViewDataSource, CZAttentionCellDelegate>
/** 关注列表 */
@property (nonatomic, strong) NSMutableArray *attentionsData;

@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noAttentionView;
@property (nonatomic, strong) CZNoDataView *noFansView;
@end

@implementation CZAttentionController
- (CZNoDataView *)noAttentionView
{
    if (_noAttentionView == nil) {
        self.noAttentionView = [CZNoDataView noAttentionView];
        self.noAttentionView.centerX = SCR_WIDTH / 2.0;
        self.noAttentionView.y = 170;
    }
    return _noAttentionView;
}

- (CZNoDataView *)noFansView
{
    if (_noFansView == nil) {
        self.noFansView = [CZNoDataView noFansView];
        self.noFansView.centerX = SCR_WIDTH / 2.0;
        self.noFansView.y = 170;
    }
    return _noFansView;
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + 50.7)) style:UITableViewStylePlain];;
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
    self.page = 1;
    
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    NSString *url;
    if ([self.type isEqualToString:@"1"]) {    
        url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/list"];
    } else {
        url = [JPSERVER_URL stringByAppendingPathComponent:@"api/fans/list"];
    }
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"])
        {
            if ([result[@"data"] count] > 0) {
                // 删除nodata
                if ([self.type isEqualToString:@"1"]) { 
                    [self.noAttentionView removeFromSuperview];
                } else {
                    [self.noFansView removeFromSuperview];
                }
            } else {
                // 没有数据图片
                if ([self.type isEqualToString:@"1"]) { 
                    [self.tableView addSubview:self.noAttentionView];
                } else {
                    [self.tableView addSubview:self.noFansView];
                }
            }
            // 字典转模型
            self.attentionsData = [CZAttentionsModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    param[@"page"] = @(self.page);
    NSString *url;
    if ([self.type isEqualToString:@"1"]) {    
        url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/list"];
    } else {
        url = [JPSERVER_URL stringByAppendingPathComponent:@"api/fans/list"];
    };
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"list"] count] != 0)
        {
            // 字典转模型
            NSArray *attentions = [CZAttentionsModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    if (![self.type isEqualToString:@"1"]) { 
        model.cellType = @"fans";
    } else {
        model.cellType = @"follow";
    }
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
//    CZAttentionsModel *model = self.attentionsData[indexPath.row];
//    CZAttentionDetailController *vc = [[CZAttentionDetailController alloc] init];
//    vc.model = model;
//    [self.navigationController pushViewController:vc animated:YES];
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
