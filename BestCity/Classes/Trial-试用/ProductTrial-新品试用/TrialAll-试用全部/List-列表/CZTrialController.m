//
//  CZTrialController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialController.h"
#import "CZNavigationView.h"
#import "CZTrialMainCell.h"
#import "CZTrialDetailController.h"
// 工具
#import "GXNetTool.h"
//模型
#import "CZTrailModel.h"

@interface CZTrialController () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 试用数据 */
@property (nonatomic, strong) NSMutableArray *trialDatasArr;
@end

@implementation CZTrialController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67.7, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7 + (IsiPhoneX ? 34 : 0))) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    [CZTrailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"trialId" : @"id"
                 }; 
    }];
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
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.trialDatasArr = [CZTrailModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *newArr = [CZTrailModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.trialDatasArr addObjectsFromArray:newArr];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"全部试用" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];
    
    // 表
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];
}


// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trialDatasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrialMainCell *cell = [CZTrialMainCell cellWithTableView:tableView];
    cell.trailModel = self.trialDatasArr[indexPath.row];
    return cell;
}

// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 325;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        CZTrialDetailController *vc = [[CZTrialDetailController alloc] init];
        CZTrailModel *model = self.trialDatasArr[indexPath.row];
        vc.trialId = model.trialId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
@end
