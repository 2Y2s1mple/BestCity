//
//  CZFreeSubTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeSubTwoController.h"
#import "CZFreeTakePartInCell.h"
// 工具
#import "GXNetTool.h"

@interface CZFreeSubTwoController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 拉赞数据 */
@property (nonatomic, strong) NSMutableArray *DatasArr;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;

@end

@implementation CZFreeSubTwoController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = self.tableView.tableHeaderView.height;
    }
    return _noDataView;
}
- (NSMutableArray *)DatasArr
{
    if (_DatasArr == nil) {
        _DatasArr = [NSMutableArray array];
    }
    return _DatasArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalLightGray;
    self.view.autoresizingMask = UIViewAutoresizingNone;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - 50 - (IsiPhoneX ? 83 : 49) - (IsiPhoneX ? 44 : 20)) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    [self reloadNewTrailDataSorce];
    [self setupRefresh];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentViewIsScroll:) name:@"CZFreeDetailsubViewNoti" object:nil];

}

- (void)currentViewIsScroll:(NSNotification *)noti
{
    NSLog(@"%@", noti.userInfo[@"isScroller"]);
    if ([noti.userInfo[@"isScroller"]  isEqual: @(1)]) {
        self.tableView.scrollEnabled = YES;
    } else {
        self.tableView.scrollEnabled = NO;
    }
}

#pragma mark - 获取数据
- (void)setupRefresh
{
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
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
    param[@"page"] = @(self.page);
    param[@"freeId"] = self.freeID;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/free/freeUserList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
            }
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
    self.page++;
    [self.tableView.mj_header endRefreshing];
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"freeId"] = self.freeID;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/free/freeUserList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *newArr = result[@"data"];
            [self.DatasArr addObjectsFromArray:newArr];
            [self.tableView reloadData];
            if ([self.DatasArr count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
            }
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
    CZFreeTakePartInCell *cell = [CZFreeTakePartInCell cellWithTableView:tableView];
    cell.numbersLabel.text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1)];
    cell.dic = self.DatasArr[indexPath.row];
    return cell;
}

// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat scrollOffsetY = 0.0;
    NSLog(@"%s %lf", __func__, scrollView.contentOffset.y);
    if (scrollOffsetY > scrollView.contentOffset.y) {
        NSLog(@"向下");
        if (scrollView.contentOffset.y <= 0) {
            scrollView.scrollEnabled = NO; // 不滚
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeChargeDetailControllerNoti" object:nil userInfo:@{@"isScroller" : @(YES)}];
        }
    } else {
        NSLog(@"向上");
    }
    scrollOffsetY = scrollView.contentOffset.y;
}

- (void)scrollTop
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
}
@end
