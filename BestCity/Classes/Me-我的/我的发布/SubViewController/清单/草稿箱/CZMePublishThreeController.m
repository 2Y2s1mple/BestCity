//
//  CZMePublishOneController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMePublishThreeController.h"
#import "CZEInventoryEditorController.h"
#import "GXNetTool.h"

#import "CZETestModel.h"
// 视图
#import "CZMePublishOneCell.h"
#import "CZUpdataView.h"



@interface CZMePublishThreeController () <UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CZMePublishThreeController

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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDiscover)];
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

#pragma mark - 加载第一页
- (void)reloadNewDiscover
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //    （状态 0:草稿箱 1:审核中 2:已发布 -1：未通过）
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"status"] = @(0);

    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/my/article/listingList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {

        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
            self.dataSource = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    //    （状态 0:草稿箱 1:审核中 2:已发布 -1：未通过）
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"status"] = @(0);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/my/article/listingList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"data"] count] != 0) {
            NSArray *list = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZETestModel *model = self.dataSource[indexPath.row];
    CZMePublishOneCell *cell = [CZMePublishOneCell cellwithTableView3:tableView];
    [cell setAction:^(CZMePublishOneCell * _Nonnull cell) {
        NSIndexPath *indexPath1 = [tableView indexPathForCell:cell];
        [self.dataSource removeObjectAtIndex:indexPath1.row];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-----");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        CZUpdataView *backView = [CZUpdataView reminderView];
        backView.frame = [UIScreen mainScreen].bounds;
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [[UIApplication sharedApplication].keyWindow addSubview: backView];
        [backView setConfirmBlock:^{
            CZETestModel *model = self.dataSource[indexPath.row];
            [self deleteItemID: model.articleId atIndexPath:indexPath];
        }];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";

}

#pragma mark - 加载第一页
- (void)deleteItemID:(NSString *)ID atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"articleId"] = ID;

     [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/my/article/delete"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [self.dataSource removeObjectAtIndex:indexPath.row];

            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}


@end
