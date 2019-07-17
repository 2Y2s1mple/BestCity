//
//  CZMHSDQuestController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDQuestController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
// 视图
#import "CZMHSDQuestCell.h"
// 模型
#import "CZMHSDQuestModel.h"
// 跳转
#import "CZMHSDQDetailController.h"
#import "CZMHSAskQuestionController.h"

@interface CZMHSDQuestController () <UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 导航条 */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CZMHSDQuestController
// 导航条
- (CZNavigationView *)navigationView
{
    if (_navigationView == nil) {
        _navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.titleText rightBtnTitle:[UIImage imageNamed:@"Forward"] rightBtnAction:^{
            CZMHSAskQuestionController *vc = [[CZMHSAskQuestionController alloc] init];
            vc.goodsCategoryId = self.ID;
            [self.navigationController pushViewController:vc animated:YES];
        } navigationViewType  :CZNavigationViewTypeBlack];
        _navigationView.backgroundColor = CZGlobalWhiteBg;
        [self.view addSubview:_navigationView];
        //导航条
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationView.height - 0.7, _navigationView.width, 0.7)];
        line.backgroundColor = CZGlobalLightGray;
        [_navigationView addSubview:line];
    }
    return _navigationView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 24 : 0) - 67) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [CZMHSDQuestModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                    @"ID" : @"id"
                 };
    }];
    self.view.backgroundColor = CZGlobalWhiteBg;
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
//    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsCategoryId"] = self.ID;
    param[@"page"] = @(self.page);

    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/question/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = [CZMHSDQuestModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    param[@"goodsCategoryId"] = self.ID;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/question/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *arr = [CZMHSDQuestModel objectArrayWithKeyValuesArray:result[@"data"]] ;
            [self.dataSource addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     CZMHSDQuestModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMHSDQuestModel *model = self.dataSource[indexPath.row];
    CZMHSDQuestCell *cell = [CZMHSDQuestCell cellwithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMHSDQuestModel *model = self.dataSource[indexPath.row];
    CZMHSDQDetailController *vc = [[CZMHSDQDetailController alloc] init];
    vc.ID = self.ID;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
