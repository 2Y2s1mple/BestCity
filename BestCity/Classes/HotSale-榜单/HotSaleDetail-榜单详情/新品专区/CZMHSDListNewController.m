//
//  CZMHSDListNewController.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDListNewController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"
#import "CZDiscoverDetailModel.h"
#import "CZMHSDListNewCell.h"
// 跳转
#import "CZDChoiceDetailController.h"


@interface CZMHSDListNewController ()<UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
@end

@implementation CZMHSDListNewController
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

// 导航条
- (CZNavigationView *)navigationView
{
    if (_navigationView == nil) {
        _navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"新品专区" rightBtnTitle:nil rightBtnAction:nil navigationViewType  :CZNavigationViewTypeBlack];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,  0, SCR_WIDTH, SCR_HEIGHT) style:UITableViewStylePlain];
        _tableView.tableHeaderView = [self createHeaderView];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)createHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.height = 200;
    headerView.width = SCR_WIDTH;

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.height = 200;
    imageView.width = SCR_WIDTH;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    [headerView addSubview:imageView];

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn setImage:[UIImage imageNamed:@"back-white"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 30, 49, 20);
    leftBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:leftBtn];
    return headerView;
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建表
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.navigationView];
    self.navigationView.hidden = YES;

    [self setupRefresh];
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
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
    param[@"categoryId"] = @"";
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/listnew"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = [CZDiscoverDetailModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    param[@"categoryId"] = @"";
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/listnew"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *arr = [CZDiscoverDetailModel objectArrayWithKeyValuesArray:result[@"data"]];;
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
    CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
    CZMHSDListNewCell *cell = [CZMHSDListNewCell cellwithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.detailType = [CZJIPINSynthesisTool getModuleType:[model.type integerValue]];
    vc.findgoodsId = model.articleId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= (200 - 67)) {
        NSLog(@"显示");
        self.navigationView.hidden = NO;
    } else {
        NSLog(@"不显示");
        self.navigationView.hidden = YES;
    }
}
@end
