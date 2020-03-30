//
//  CZSubSubIssueMomentsListController.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSubSubIssueMomentsListController.h"
#import "CZCategoryLineLayoutView.h"

#import "CZIssueMomentsModel.h"
#import "GXNetTool.h"
#import "CZTaobaoDetailController.h"
#import "CZIssueMomentsCell.h"

@interface CZSubSubIssueMomentsListController () <UITableViewDelegate, UITableViewDataSource>
/** 二级 */
@property (nonatomic, strong) NSString *paramCategoryId2;
/** 设置选中的第几个 */
@property (nonatomic, assign) NSInteger selecedIndex;
/** 3级 */
@property (nonatomic, strong) CZCategoryLineLayoutView *categoryView3;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 记录参数 */
@property (nonatomic, strong) NSDictionary *recordParam;
@property (nonatomic, strong) NSMutableArray *listData;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZSubSubIssueMomentsListController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 180;
        self.noDataView.backgroundColor = [UIColor clearColor];
    }
    return _noDataView;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat y = CZGetY(self.categoryView3);
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCR_WIDTH, self.view.height - y) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.categoryView2Data.count > 0) {
        [self createView3];
    }

    [self.view addSubview:self.tableView];

    [self setupRefresh];

    // 获取列表数据
    [self.tableView.mj_header beginRefreshing];

}

- (void)createView3
{
    CGRect frame = CGRectMake(0, 0, SCR_WIDTH, 45);
    // 分类的按钮
    NSArray *categoryList = [CZCategoryLineLayoutView categoryItems:self.categoryView2Data setupNameKey:@"title" imageKey:@"img" IdKey:@"id" objectKey:@""];

    for (CZCategoryItem *item in categoryList) {
        item.selecedIndex = self.selecedIndex;
    }

    self.paramCategoryId2 = [categoryList[self.selecedIndex] categoryId];
    self.categoryView3 = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:4 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
        NSLog(@"%@", item.categoryName);
        self.paramCategoryId2 = item.categoryId;
        // 获取列表数据
        [self.tableView.mj_header beginRefreshing];
    }];
    self.categoryView3.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.view addSubview:self.categoryView3];

    // 获取列表数据
    [self.tableView.mj_header beginRefreshing];

    if (1) {
        UIButton *btn = [[UIButton alloc] init];
        [self.categoryView3 addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"moments-2"] forState:UIControlStateNormal];
        btn.x = SCR_WIDTH - 50;
        btn.width = 50;
        btn.height = self.categoryView3.height;
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(alerView) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getListData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}


- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.paramType;
    param[@"categoryId1"] = self.paramCategoryId1;
    param[@"categoryId2"] = self.paramCategoryId2;
    param[@"page"] = @(self.page);
    self.recordParam = param;

    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/moment/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (self.recordParam != param) return;
        if ([result[@"code"] isEqual:@(0)]) {
            for (NSDictionary *dic in result[@"data"]) {
                CZIssueMomentsModel *model = [[CZIssueMomentsModel alloc] init];
                model.param = dic;
                [self.listData addObject:model];
            }

            [self.tableView reloadData];

            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.tableView.mj_footer endRefreshing];
            } else {
                // 加载NnoData图片
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

// 获取列表数据
- (void)getListData
{
    self.page = 1;
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.paramType;
    param[@"categoryId1"] = self.paramCategoryId1;
    param[@"categoryId2"] = self.paramCategoryId2;
    param[@"page"] = @(self.page);

    self.recordParam = param;

    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/moment/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (self.recordParam != param) return;

        if ([result[@"code"] isEqual:@(0)]) {
            self.listData = [NSMutableArray array];
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
            }

            for (NSDictionary *dic in result[@"data"]) {
                CZIssueMomentsModel *model = [[CZIssueMomentsModel alloc] init];
                model.param = dic;
                [self.listData addObject:model];
            }

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZIssueMomentsModel *model = self.listData[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZIssueMomentsCell *cell = [CZIssueMomentsCell cellwithTableView:tableView];
    cell.param = self.listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZIssueMomentsModel *model = self.listData[indexPath.row];
    if (![model.param[@"goodsInfo"] isKindOfClass:[NSNull class]]) {
        CZTaobaoDetailController *vc = [[CZTaobaoDetailController alloc] init];
        vc.otherGoodsId = model.param[@"goodsInfo"][@"otherGoodsId"];
        CURRENTVC(currentVc)
        [currentVc.navigationController pushViewController:vc animated:YES];
    }
}

@end
