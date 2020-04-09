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
/** 弹窗 */
@property (nonatomic, strong) UIView *alertBackView;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGFloat y = CZGetY(self.categoryView3);
    self.tableView.frame = CGRectMake(0, y, SCR_WIDTH, self.view.height - y);
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
    self.categoryView3 = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:CZCategoryLineLayoutViewTypeDefault didClickedIndex:^(CZCategoryItem * _Nonnull item) {
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
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
- (void)reloadNewTrailDataSorce
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

#pragma mark - 弹窗
- (void)alerView
{
    UIView *backView = [[UIView alloc] init];
    backView.width = SCR_WIDTH;
    backView.height = SCR_HEIGHT;
    [self.view addSubview:backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alerViewAction:)];
    [backView addGestureRecognizer:tap];
    self.alertBackView = backView;


    // 上蒙版
    UIView *top = [[UIView alloc] init];
    top.width = SCR_WIDTH;
    top.height = self.categoryView3.y;
//    top.backgroundColor = [UIColor redColor];
    [backView addSubview:top];


    //
    UIView *alertView = [[UIView alloc] init];
    alertView.y = self.categoryView3.y;
    alertView.width = SCR_WIDTH;
    alertView.height = 200;
    alertView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [backView addSubview:alertView];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 15, 53.0, 18.2);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"全部频道"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]}];
    label.attributedText = string;
    [alertView addSubview:label];

    UIButton *btn = [[UIButton alloc] init];
    [alertView addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"moments-1"] forState:UIControlStateNormal];
    btn.x = SCR_WIDTH - 50;
    btn.width = 50;
    btn.height = 50;
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(alerViewAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *recoredBtn;
    NSInteger colIndex = 0;
    NSInteger rowIndex = 0;

    for (int i = 0; i < self.categoryView2Data.count; i++) {

        NSString *title = self.categoryView2Data[i][@"title"];
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x565252) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xE25838) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
        [btn sizeToFit];
        btn.height = 25;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        btn.width += 10;

        CGFloat maxW = CZGetX(recoredBtn);

        if (i == 0) { // 第一次什么也不做

        } else {
            if (SCR_WIDTH - maxW > (btn.width + 15)) { // 还能放
                colIndex++;
            } else {
                colIndex = 0;
                rowIndex++;
            }
        }

        btn.x = 10 + colIndex * (btn.width + 17);
        btn.y = 54 + rowIndex * (btn.height + 20);
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(alertViewDidClicked:) forControlEvents:UIControlEventTouchUpInside];

        [alertView addSubview:btn];
        recoredBtn = btn;

        alertView.height = CZGetY(btn) + 23;
    }

    UIView *bottom = [[UIView alloc] init];
    bottom.y = CZGetY(alertView);
    bottom.width = SCR_WIDTH;
    bottom.height = SCR_HEIGHT - bottom.y;
    bottom.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [backView addSubview:bottom];
}

- (void)alerViewAction:(UIButton *)sender
{
    [self.alertBackView removeFromSuperview];
}

- (void)alertViewDidClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag - 100;
    [self.categoryView3 removeFromSuperview];
    self.selecedIndex = tag;
    [self createView3];
    [self.alertBackView removeFromSuperview];
}
@end
