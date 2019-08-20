//
//  CZMeIntelligentSubController.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMeIntelligentSubController.h"
// 工具
#import "GXNetTool.h"
#import "CZETestModel.h"
#import "CZETestContrastCell.h"
#import "CZEInventoryCell.h"
#import "CZDChoiceDetailController.h"

// 视图
#import "CZMHSDQuestCell.h"
// 模型
#import "CZMHSDQuestModel.h"
// 跳转
#import "CZMHSDQDetailController.h"

@interface CZMeIntelligentSubController () <UITableViewDelegate, UITableViewDataSource>
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 拉赞数据 */
@property (nonatomic, strong) NSMutableArray *DatasArr;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZMeIntelligentSubController

#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 30;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = CZGlobalLightGray;
    self.view.autoresizingMask = UIViewAutoresizingNone;

    self.tableView = [[CZTableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - 50 - (IsiPhoneX ? 22 : 0)) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [self.view addSubview:self.tableView];

    [self reloadNewTrailDataSorce];
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
    param[@"targetUserId"] = self.freeID;
    param[@"type"] = self.type;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/user/article/listByUserId"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
            }
            if ([self.type  isEqual: @"3"]) {
                self.DatasArr = [CZMHSDQuestModel objectArrayWithKeyValuesArray:result[@"data"]];
            } else {
                self.DatasArr = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];
            }
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
    param[@"targetUserId"] = self.freeID;
    param[@"type"] = self.type;
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/user/user/article/listByUserId"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([self.type  isEqual: @"3"]) {
                NSArray *newArr = [CZMHSDQuestModel objectArrayWithKeyValuesArray:result[@"data"]];
                [self.DatasArr addObjectsFromArray:newArr];
            } else {
                NSArray *newArr = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];
                [self.DatasArr addObjectsFromArray:newArr];
            }
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
 //分类（2清单，3问答，4评测）
    if ([self.type  isEqual: @"2"]) {
        CZETestModel *model = self.DatasArr[indexPath.row];
        CZEInventoryCell *cell = [CZEInventoryCell cellwithTableView:tableView];
        cell.model = model;
        return cell;
    } else if ([self.type  isEqual: @"4"]) {
        CZETestModel *model = self.DatasArr[indexPath.row];
        CZETestContrastCell *cell = [CZETestContrastCell cellwithTableView:tableView];
        cell.model = model;
        return cell;
    } else {
        CZMHSDQuestModel *model = self.DatasArr[indexPath.row];
        CZMHSDQuestCell *cell = [CZMHSDQuestCell cellwithTableView:tableView];
        cell.model = model;
        return cell;
    }
}

// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type  isEqual: @"2"]) {
        CZETestModel *model = self.DatasArr[indexPath.row];
        return model.cellHeight;
    } if ([self.type  isEqual: @"3"]) {
        CZMHSDQuestModel *model = self.DatasArr[indexPath.row];
        return model.cellHeight;
    } else {
        CZETestModel *model = self.DatasArr[indexPath.row];
        return model.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type  isEqual: @"3"]) {
        CZMHSDQuestModel *model = self.DatasArr[indexPath.row];
        CZMHSDQDetailController *vc = [[CZMHSDQDetailController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CZETestModel *model = self.DatasArr[indexPath.row];
        //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = [CZJIPINSynthesisTool getModuleType:[model.type integerValue]];
        vc.findgoodsId = model.articleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CZFreeChargeDetailControllerNoti" object:nil userInfo:@{@"isScroller" : scrollView}];
}

@end
