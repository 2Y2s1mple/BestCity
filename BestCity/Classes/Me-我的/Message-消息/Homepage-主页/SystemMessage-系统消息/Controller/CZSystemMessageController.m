//
//  CZSystemMessageController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSystemMessageController.h"
#import "CZNavigationView.h"
#import "Masonry.h"
#import "CZSystemMessageCell.h"
#import "CZSystemMessageDetailController.h"
#import "MJRefresh.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "CZSystemMessageModel.h"

@interface CZSystemMessageController ()<UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZSystemMessageController
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.backgroundColor = CZGlobalLightGray;
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 140;
    }
    return _noDataView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CZSystemMessageModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"contentID" : @"id"
                 };
    }];
    
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"系统消息" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(68 + (IsiPhoneX ? 24 : 0));
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.tableView = tableView;
    // 创建刷新控件
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 进来先刷一次
    [self.tableView.mj_header beginRefreshing];
}

/** 加载刷新控件*/
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNowData)];
    // 进来先刷一次
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

// 刷新
- (void)loadNowData
{
    // 结束footer
    [self.tableView.mj_footer endRefreshing];
    
    // 加载数据
    self.page = 0;
    
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"1";
    param[@"page"] = @(self.page);
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/message/selectAll"];
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"])
        {
            if ([result[@"list"] count] > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
            
            // 字典转模型
            self.dataSource = [CZSystemMessageModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.tableView reloadData];
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
- (void)loadMoreData
{
    self.page++;
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"1";
    param[@"page"] = @(self.page);
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/message/selectAll"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"list"] count] != 0)
        {
            // 字典转模型
            NSArray *message = [CZSystemMessageModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.dataSource addObjectsFromArray:message];
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
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZSystemMessageCell *cell = [CZSystemMessageCell cellWithTabelView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZSystemMessageModel *model = self.dataSource[indexPath.row];
    CZSystemMessageDetailController *vc = [[CZSystemMessageDetailController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
