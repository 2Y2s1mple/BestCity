//
//  CZReportAllListController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZReportAllListController.h"
#import "CZNavigationView.h"
#import "CZTrailTestCell.h"
// 工具
#import "GXNetTool.h"

@interface CZReportAllListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;

/** 拉赞数据 */
@property (nonatomic, strong) NSMutableArray *DatasArr;
@end

@implementation CZReportAllListController

- (NSMutableArray *)DatasArr
{
    if (_DatasArr == nil) {
        _DatasArr = [NSMutableArray array];
    }
    return _DatasArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"拉赞排行" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CZGetY(navigationView), SCR_WIDTH, SCR_HEIGHT - CZGetY(navigationView)) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self setupRefresh];
}

#pragma mark - 获取数据
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
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"trialId"] = self.dataSource[@"id"]; 
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/voteUserList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [self.DatasArr addObjectsFromArray:result[@"data"]];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"trialId"] = self.dataSource[@"id"]; 
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/voteUserList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *newArr = result[@"data"];
            [self.DatasArr addObjectsFromArray:newArr];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DatasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrailTestCell *cell = [CZTrailTestCell cellWithTableView:tableView];
    cell.numbersLabel.text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1)];
    cell.dic = self.DatasArr[indexPath.row];
    return cell;
}

// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

@end
