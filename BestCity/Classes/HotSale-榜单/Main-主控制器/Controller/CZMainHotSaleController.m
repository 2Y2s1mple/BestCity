//
//  CZMainHotSaleController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainHotSaleController.h"

// 工具
#import "GXNetTool.h"

// 视图
#import "CZMainHotSaleHeaderView.h"
#import "CZMainHotSaleCategoryView.h"
#import "CZMainHotSaleCell.h"

// 模型
#import "CZHotTitleModel.h"

// 跳转
#import "CZHotsaleSearchController.h"

@interface CZMainHotSaleController () <UITableViewDelegate, UITableViewDataSource>
/** 滚动 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 记录btn */
@property (nonatomic, strong) UIButton *recordBtn;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 新品专区 */
@property (nonatomic, strong) NSDictionary *listNew;
@end

@implementation CZMainHotSaleController
#pragma mark - 创建视图
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49));
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)setupHeaderView
{
    CZMainHotSaleHeaderView *headerView = [[CZMainHotSaleHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 209) action:^{
        ISPUSHLOGIN
        NSString *text = @"首页搜索框";
        NSDictionary *context = @{@"message" : text};
        [MobClick event:@"ID1" attributes:context];
        CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return headerView;
}

- (UIView * (^)(NSArray *))createCategoryView
{
    return ^(NSArray *category){
        // 创建菜单视图
        CZMainHotSaleCategoryView *categoryView = [[CZMainHotSaleCategoryView alloc] initWithFrame:CGRectMake(0, 209, SCR_WIDTH, 0) action:^(CGFloat height) {
            self.tableView.tableHeaderView.height = height + 209;
            [self.tableView reloadData];
        }];
        categoryView.dataSource = category;
        return categoryView;
    };
}

- (UIView * (^)(NSArray *))createTableViewHeaderView
{
    return ^(NSArray *data) {
        UIView *headerView = [[UIView alloc] init];
        // 头部视图
        [headerView addSubview:self.setupHeaderView];
        // 创建菜单视图
        [headerView addSubview:self.createCategoryView(data)];
        headerView.size = CGSizeMake(0, CZGetY([headerView.subviews lastObject]));
        return headerView;
    };
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSorce)];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    // 获取数据
    WS(weakself);
    [self getCategoryListData:^(NSArray<CZHotTitleModel *> *modelList) {
        weakself.tableView.tableHeaderView = weakself.createTableViewHeaderView(modelList);
    }];
}

#pragma mark - 数据
- (instancetype)getCategoryListData:(void (^)(NSArray <CZHotTitleModel *> *))categoryList
{
    [CZHotTitleModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"children" : @"CZHotSubTilteModel"
                 };
    }];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsCategoryList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *list = result[@"data"];
            //标题的数据
            categoryList([CZHotTitleModel objectArrayWithKeyValuesArray:list]);
        }
    } failure:^(NSError *error) {
    }];
    return self;
}

- (instancetype)getListData:(void (^)(NSDictionary *))listData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(page_);
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getTopCategorysList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            listData(result);

        }
    } failure:^(NSError *error) {}];
    return self;
}

static NSInteger page_ = 1;
- (void)reloadNewDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    WS(weakself);
    page_ = 1;
    [self getListData:^(NSDictionary *data) {
       weakself.dataSource = [NSMutableArray arrayWithArray:data[@"data"]];
        self.listNew = data[@"ad"];
        [weakself.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreDataSorce
{
    [self.tableView.mj_header endRefreshing];
    WS(weakself);
    page_++;
    [self getListData:^(NSDictionary *data) {
        [weakself.dataSource addObjectsFromArray:data[@"data"]];
        [weakself.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 228;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMainHotSaleCell *cell = [CZMainHotSaleCell cellwithTableView:tableView];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end
