//
//  CZMeAnswersPublishTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMeAnswersPublishTwoController.h"
#import "GXNetTool.h"
// 视图
#import "CZMHSDQuestCell1.h"
// 模型
#import "CZMHSDQuestModel.h"
// 跳转
#import "CZMHSDQDetailController.h"

@interface CZMeAnswersPublishTwoController () <UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CZMeAnswersPublishTwoController
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [CZMHSDQuestModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];

    CZTOPLINE;
    [self.view addSubview:self.tableView];

    // 加载刷新数据
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, SCR_WIDTH, self.view.height);
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDiscover)];
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

#pragma mark - 加载第一页
- (void)reloadNewDiscover
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //    （1商品，2清单，3问答，4评测，5试用报告）
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"status"] = @(0); // 0:审核中

    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/my/question/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {

        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
            self.dataSource = [CZMHSDQuestModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 加载更多数据
- (void)loadMoreDiscover
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //    （1商品，2清单，3问答，4评测，5试用报告）
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"status"] = @(0); // 0:审核中
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/my/question/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"data"] count] != 0) {
            NSArray *list = [CZMHSDQuestModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.dataSource addObjectsFromArray:list];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMHSDQuestModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMHSDQuestModel *model = self.dataSource[indexPath.row];
    CZMHSDQuestCell1 *cell = [CZMHSDQuestCell1 cellwithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMHSDQuestModel *model = self.dataSource[indexPath.row];
    CZMHSDQDetailController *vc = [[CZMHSDQDetailController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
