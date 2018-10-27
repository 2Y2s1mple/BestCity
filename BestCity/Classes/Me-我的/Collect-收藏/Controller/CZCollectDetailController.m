//
//  CZCollectDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCollectDetailController.h"
#import "CZCollectCell.h"
#import "CZCollectionModel.h"
#import "MJExtension.h"
#import "GXNetTool.h"
#import "MJRefresh.h"

@interface CZCollectDetailController ()<UITableViewDelegate, UITableViewDataSource>
/** 收藏数据 */
@property (nonatomic, strong) NSMutableArray *collectdsData;
/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation CZCollectDetailController

- (NSMutableArray *)collectdsData
{
    if (_collectdsData == nil) {
        _collectdsData = [NSMutableArray array];
    }
    return _collectdsData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - 68 - 50) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    // 加载刷新控件
    [self setupRefresh];

}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //刷新
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/** 加载新数据 */
- (void)loadNewData
{
    // 结束footer刷新
    [self.tableView.mj_footer endRefreshing];
    
    // 页数
    self.page = 0;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    param[@"page"] = @(self.page);
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collect"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.collectdsData = [CZCollectionModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.tableView reloadData];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"无数据"];
            [CZProgressHUD hideAfterDelay:2];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 加载更多数据 */
- (void)loadMoreData
{
    // 页数
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    param[@"page"] = @(self.page);
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/collect"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
//        NSLog(@"%@", result);      
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *collections = [CZCollectionModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.collectdsData addObjectsFromArray:collections];
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        } else {
            // 显示无数据
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        // 页数
        self.page--;
    }];
}



#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZCollectionModel *model = self.collectdsData[indexPath.row];
    CZCollectCell *cell = [CZCollectCell cellWithTabelView:tableView];
    cell.model = model;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectdsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

@end
