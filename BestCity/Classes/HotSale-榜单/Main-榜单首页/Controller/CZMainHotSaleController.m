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
#import "CZUpdataManger.h"
// 模型
#import "CZHotTitleModel.h"
// 跳转
#import "CZHotsaleSearchController.h"
#import "CZMainHotSaleDetailController.h"
#import "CZMHSDListNewController.h"

@interface CZMainHotSaleController () <UITableViewDelegate, UITableViewDataSource>
/** 记录btn */
@property (nonatomic, strong) UIButton *recordBtn;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 新品专区 */
@property (nonatomic, strong) NSDictionary *adDic;
/** 显示的导航栏 */
@property (nonatomic, strong) UIView *navTopView;
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
        [self pushSearchView];
    }];
    return headerView;
}

- (UIView *)navTopView
{
    if (_navTopView == nil) {
        _navTopView = [[CZMainHotSaleHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 0) pushAction:^{
            [self pushSearchView];
        }];
    }
    return _navTopView;
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

// tableView的头部视图
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
    // 隐藏和显示的头部view
    [self.view addSubview:self.navTopView];
    self.navTopView.hidden = YES;

    // 显示版本更新
     [CZUpdataManger ShowUpdataViewWithNetworkService];
}

#pragma mark - 网络请求
- (instancetype)getCategoryListData:(void (^)(NSArray <CZHotTitleModel *> *))categoryList
{
    [CZHotTitleModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"children" : @"CZHotSubTilteModel"
                 };
    }];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/goodsCategoryList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *list = result[@"data"];
            //标题的数据
            categoryList([CZHotTitleModel objectArrayWithKeyValuesArray:list]);
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    return self;
}

- (instancetype)getListData:(void (^)(NSDictionary *))listData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(page_);
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/getTopCategorysList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            listData(result);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
    return self;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 195;
    } else {
        return 228;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CZMainHotSaleCell *cell = [CZMainHotSaleCell cellwithTableView:tableView];
    if (indexPath.row == 0) {
        cell.adDic = self.adDic;
    } else {
        cell.data = self.dataSource[indexPath.row - 1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CZMHSDListNewController *vc = [[CZMHSDListNewController alloc] init];
        vc.data = self.adDic;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSDictionary *model = self.dataSource[indexPath.row - 1];
        CZMainHotSaleDetailController *vc = [[CZMainHotSaleDetailController alloc] init];
        vc.ID = model[@"categoryId"];
        vc.titleText = [NSString stringWithFormat:@"%@榜单", model[@"categoryName"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= (209 - (IsiPhoneX ? 44 : 20) - 45)) {
        NSLog(@"显示");
        self.navTopView.hidden = NO;
    } else {
        NSLog(@"不显示");
        self.navTopView.hidden = YES;
    }
}

#pragma mark - 事件
// 跳转到搜索页面
- (void)pushSearchView
{
    NSString *text = @"首页搜索框";
    NSDictionary *context = @{@"message" : text};
    [MobClick event:@"ID1" attributes:context];
    CZHotsaleSearchController *vc = [[CZHotsaleSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 下拉加载
static NSInteger page_ = 1;
- (void)reloadNewDataSorce
{
    WS(weakself);
    if (self.tableView.tableHeaderView == nil) {
        [self getCategoryListData:^(NSArray<CZHotTitleModel *> *modelList) {
            weakself.tableView.tableHeaderView = weakself.createTableViewHeaderView(modelList);
        }];
    }

    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    page_ = 1;
    [self getListData:^(NSDictionary *data) {
        weakself.dataSource = [NSMutableArray arrayWithArray:data[@"data"]];
        self.adDic = data[@"ad"];
        [weakself.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

// 上拉刷新
- (void)loadMoreDataSorce
{
    [self.tableView.mj_header endRefreshing];
    WS(weakself);
    page_++;
    [self getListData:^(NSDictionary *data) {
        if ([data[@"data"] count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [weakself.dataSource addObjectsFromArray:data[@"data"]];
        [weakself.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
