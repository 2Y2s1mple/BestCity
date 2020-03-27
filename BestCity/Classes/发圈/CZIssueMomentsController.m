//
//  CZIssueMomentsController.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/16.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZIssueMomentsController.h"
#import "CZNavigationView.h"
#import "CZCategoryLineLayoutView.h"
#import "GXNetTool.h"
#import "CZIssueMomentsCell.h"
#import "CZIssueMomentsModel.h"
#import "CZTaobaoDetailController.h"

//测试
#import "CZJIPINSynthesisView.h"

@interface CZIssueMomentsController ()  <UITableViewDelegate, UITableViewDataSource>
/** 顶部的红条 */
@property (nonatomic, strong) UIView *topview;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 1级 */
@property (nonatomic, strong) CZCategoryLineLayoutView *categoryView1;
/** 2级 */
@property (nonatomic, strong) CZCategoryLineLayoutView *categoryView2;
/** 3级 */
@property (nonatomic, strong) CZCategoryLineLayoutView *categoryView3;
/** 3级数据 */
@property (nonatomic, strong) NSArray *categoryView3Data;

/** 弹窗 */
@property (nonatomic, strong) UIView *backView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 总数据 */
@property (nonatomic, strong) NSArray *dataSource;

/** 模块 */
@property (nonatomic, strong) NSNumber *paramType; // 1精选 2.素材
/** 一级 */
@property (nonatomic, strong) NSString *paramCategoryId2;
/** 二级 */
@property (nonatomic, strong) NSString *paramCategoryId3;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *listData;

/** 设置选中的第几个 */
@property (nonatomic, assign) NSInteger selecedIndex;

/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;

/** 记录参数 */
@property (nonatomic, strong) NSDictionary *recordParam;
@end

@implementation CZIssueMomentsController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    [self getTitles];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - 获取数据
// 获取标题数据
- (void)getTitles
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @(1);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/moment/categoryList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            [self createView1];
            [self createView2];
            [self.view addSubview:self.tableView];
        }
    } failure:^(NSError *error) {

    }];
}

- (void)getTitlesWithType:(NSNumber *)type
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = type;
    self.paramCategoryId2 = @"";
    self.paramCategoryId3 = @"";
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/moment/categoryList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            [self.categoryView2 removeFromSuperview];
            [self.categoryView3 removeFromSuperview];
            [self createView2];
        }
    } failure:^(NSError *error) {

    }];
}

// 获取列表数据
- (void)getListData
{
    self.page = 1;
    [self.tableView.mj_footer endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = self.paramType;
    param[@"categoryId1"] = self.paramCategoryId2;
    param[@"categoryId2"] = self.paramCategoryId3;
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


#pragma mark - 创建UI
- (void)createView1
{
    UIView *toptop = [[UIView alloc] init];
    toptop.width = SCR_WIDTH;
    toptop.height = (IsiPhoneX ? 44 : 20);
    toptop.backgroundColor = UIColorFromRGB(0xE25838);
    [self.view addSubview:toptop];

    UIView *topview = [[UIView alloc] init];
    topview.width = SCR_WIDTH;
    topview.y = (IsiPhoneX ? 44 : 20);
    topview.height = 44;
    topview.backgroundColor = UIColorFromRGB(0xE25838);
    [self.view addSubview:topview];
    self.topview = topview;

    self.paramType = @(1);
    NSArray *categoryList = [CZCategoryLineLayoutView categoryItems:@[@"每日精选", @"宣传素材"] setupNameKey:@"categoryName" imageKey:@"img" IdKey:@"categoryId" objectKey:@""];
    CGRect frame = CGRectMake(0, 9, SCR_WIDTH, 0);
    self.categoryView1 = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:2 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
        NSLog(@"%@", item.categoryName);
        [self getTitlesWithType:@(item.index + 1)];
        self.paramType = @(item.index + 1);
    }];
    self.categoryView1.backgroundColor = [UIColor clearColor];
    [topview addSubview:self.categoryView1];
}

- (void)createView2
{
    NSArray *list = self.dataSource;
    CGRect frame = CGRectMake(0, CZGetY(self.topview), SCR_WIDTH, 50);
    // 分类的按钮
    NSArray *categoryList = [CZCategoryLineLayoutView categoryItems:list setupNameKey:@"title" imageKey:@"img" IdKey:@"id" objectKey:@"children"];
    self.paramCategoryId2 = [[categoryList firstObject] categoryId];
    self.categoryView2 = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:3 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
        NSLog(@"%@", item.categoryName);
        self.paramCategoryId2 = @"";
        self.paramCategoryId3 = @"";
        self.paramCategoryId2 =  item.categoryId;
        self.categoryView3Data = item.objectInfo;
        [self.categoryView3 removeFromSuperview];
        if (self.categoryView3Data.count == 0) {
            // 获取列表数据
            [self.tableView.mj_header beginRefreshing];
            self.tableView.y = CZGetY(self.categoryView2);;
            self.tableView.height = SCR_HEIGHT - CZGetY(self.categoryView2) - (IsiPhoneX ? 83 : 49);
        } else {
            [self createView3];
            self.tableView.y =  CZGetY(self.categoryView3);
            self.tableView.height = SCR_HEIGHT - CZGetY(self.categoryView3) - (IsiPhoneX ? 83 : 49);
        }

    }];
    self.categoryView2.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:self.categoryView2];

    // 创建三级数据
    self.categoryView3Data = self.dataSource[0][@"children"];
    if (self.categoryView3Data.count == 0) {
        self.tableView.y = CZGetY(self.categoryView2);
        self.tableView.height = SCR_HEIGHT - CZGetY(self.categoryView2) - (IsiPhoneX ? 83 : 49);
        // 获取列表数据
        [self.tableView.mj_header beginRefreshing];
    } else {
        [self createView3];
        self.tableView.y =  CZGetY(self.categoryView3);
        self.tableView.height = SCR_HEIGHT - CZGetY(self.categoryView3) - (IsiPhoneX ? 83 : 49);
    }
}

- (void)createView3
{
    CGRect frame = CGRectMake(0, CZGetY(self.categoryView2), SCR_WIDTH, 45);
    // 分类的按钮
    NSArray *categoryList = [CZCategoryLineLayoutView categoryItems:self.categoryView3Data setupNameKey:@"title" imageKey:@"img" IdKey:@"id" objectKey:@""];

    for (CZCategoryItem *item in categoryList) {
        item.selecedIndex = self.selecedIndex;
    }

    self.paramCategoryId3 = [categoryList[self.selecedIndex] categoryId];
    self.categoryView3 = [CZCategoryLineLayoutView categoryLineLayoutViewWithFrame:frame Items:categoryList type:4 didClickedIndex:^(CZCategoryItem * _Nonnull item) {
        NSLog(@"%@", item.categoryName);
        self.paramCategoryId3 = item.categoryId;
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


- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat y = CZGetY(self.categoryView3);
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCR_WIDTH, SCR_HEIGHT - y - (IsiPhoneX ? 83 : 49)) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
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
    param[@"categoryId1"] = self.paramCategoryId2;
    param[@"categoryId2"] = self.paramCategoryId3;
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
    self.backView = backView;


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

    for (int i = 0; i < self.categoryView3Data.count; i++) {

        NSString *title = self.categoryView3Data[i][@"title"];
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
    [self.backView removeFromSuperview];
}


- (void)alertViewDidClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag - 100;
    [self.categoryView3 removeFromSuperview];
    self.selecedIndex = tag;
    [self createView3];
    [self.backView removeFromSuperview];

}


@end
