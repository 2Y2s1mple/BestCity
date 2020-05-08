//
//  CZMyPointDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMyPointDetailController.h"
#import "CZNavigationView.h"
#import "CZMyPointDetailCell.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "CZPointDetailModel.h"

@interface CZMyPointDetailController ()<UITableViewDelegate , UITableViewDataSource>
/** 详情数组 */
@property (nonatomic, strong) NSMutableArray *detailsArr;
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation CZMyPointDetailController

- (NSMutableArray *)detailsArr
{
    if (_detailsArr == nil) {
        _detailsArr = [NSMutableArray array];
    }
    return _detailsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"极币明细" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, SCR_HEIGHT - 68 - (IsiPhoneX ? 24 : 0)) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDiscover)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

#pragma mark - 获得数据
- (void)reloadNewDiscover
{
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/point/list"];
    // 请求
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 赋值
            self.detailsArr = [CZPointDetailModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.tableView reloadData];
            // 隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"无数据"];
            [CZProgressHUD hideAfterDelay:2];
        }
         [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 加载更多数据
- (void)loadMoreDiscover
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/point/list"];
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"data"] count] != 0) {
            NSArray *newArr = [CZPointDetailModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.detailsArr addObjectsFromArray:newArr];
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMyPointDetailCell *cell = [CZMyPointDetailCell cellWithTabelView:tableView];
    cell.model = self.detailsArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

@end
