//
//  CZEvaluationChoicenessController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluationChoicenessController.h"
#import "CZEvaluationChoicenessCell.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "CZEvaluationChoicenessModel.h"
#import "CZEvaluationChoicenessDetailController.h"
#import "MJRefresh.h"

@interface CZEvaluationChoicenessController ()<UITableViewDelegate, UITableViewDataSource, CZEvaluationChoicenessCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation CZEvaluationChoicenessController
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, SCR_HEIGHT - 71 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = CZGlobalWhiteBg;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView = [self setupHeaderView];
    // 创建刷新控件
    [self addRefresh];
    
}

#pragma mark - 创建刷新控件
- (void)addRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 新数据接口
- (void)loadNewData
{
    // 结束footer
    [self.tableView.mj_footer endRefreshing];
    
    self.page = 0;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"categoryId"] = self.titleModel.categoryId;
    param[@"page"] = @(self.page);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/evalWay/selectList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = [CZEvaluationChoicenessModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.tableView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 加载更多数据接口
- (void)loadMoreData
{
    // 结束header
    [self.tableView.mj_header endRefreshing];
    
    self.page++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"categoryId"] = self.titleModel.categoryId;
    param[@"page"] = @(self.page);
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/evalWay/selectList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *arr = [CZEvaluationChoicenessModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.dataSource addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
         [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
         [self.tableView.mj_footer endRefreshing];
    }];
}

- (UIView *)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, FSS(180))];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"evaluating-banner"]];
    imageView.frame = CGRectMake(0, 0, SCR_WIDTH, backView.height);
    [backView addSubview:imageView];
    
    return backView;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZEvaluationChoicenessModel *model = self.dataSource[indexPath.row];
    CZEvaluationChoicenessCell *cell = [CZEvaluationChoicenessCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 454;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZEvaluationChoicenessDetailController *vc = [[CZEvaluationChoicenessDetailController alloc] init];
    CZEvaluationChoicenessModel *model = self.dataSource[indexPath.row];
    vc.detailID = model.evalWayId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <CZEvaluationChoicenessCellDelegate> 关注了调刷新
- (void)reloadCEvaluationChoicenessData
{
    NSLog(@"reloadCEvaluationChoicenessData");
    [self loadMoreData];
}
@end
