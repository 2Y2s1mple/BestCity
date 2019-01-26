//
//  CZSearchSubDetailTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZSearchSubDetailTwoController.h"
#import "MJRefresh.h"
#import "GXNetTool.h"
#import "CZDiscoverDetailModel.h"
#import "CZChoicenessCell.h"
#import "CZDChoiceDetailController.h" 

@interface CZSearchSubDetailTwoController ()<UITableViewDelegate, UITableViewDataSource>
/** tabelview */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** statusView */
@property (nonatomic, strong) UIView *statusView;
@end

@implementation CZSearchSubDetailTwoController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 170;
    }
    return _noDataView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 20)];
    statusView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:statusView];
    self.statusView = statusView;
    self.page = 1;
    self.view.backgroundColor = CZGlobalWhiteBg;
    //line
    CZTOPLINE;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, 0) style:UITableViewStylePlain];
    if (self.type == CZDChoicenessControllerTypeDiscover) {
        self.tableView.height = SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + 84 + (IsiPhoneX ? 83 : 49)) + 50;
    } else {
        self.tableView.height = SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + HOTTitleH) - (IsiPhoneX ? 83 : 49);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //创建刷新控件
    [self setupRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.statusView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.statusView.hidden = YES;
}

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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"keyword"] = self.textSearch;
    if (self.type == CZDChoicenessControllerTypeDiscover) {
        param[@"type"] = @(3); // 发现
    } else if (self.type == CZDChoicenessControllerTypeEvaluation){
        param[@"type"] = @(2); // 测评
    }  else {
        param[@"type"] = @(4); // 使用
    }
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 没有数据图片
                [self.noDataView removeFromSuperview];
            } else {
                // 没有数据图片
                [self.tableView addSubview:self.noDataView];
            }
            self.dataSource = [CZDiscoverDetailModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"keyword"] = self.textSearch;
    if (self.type == CZDChoicenessControllerTypeDiscover) {
        param[@"type"] = @(3); // 发现
    } else if (self.type == CZDChoicenessControllerTypeEvaluation){
        param[@"type"] = @(2); // 测评
    }  else {
        param[@"type"] = @(4); // 使用
    }
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/search"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"] && [result[@"data"] count] != 0) {
            NSArray *newArr = [CZDiscoverDetailModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.dataSource addObjectsFromArray:newArr];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
    if (self.type == CZDChoicenessControllerTypeDiscover) {
        static NSString *ID = @"choiceCell";
        CZChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZChoicenessCell class]) owner:nil options:nil] firstObject];
        }
        cell.model = model;
        return cell;
    } else {
        static NSString *ID1 = @"choiceCell1";
        CZChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZChoicenessCell class]) owner:nil options:nil] lastObject];
        }
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        if (self.type == CZDChoicenessControllerTypeDiscover) {        
            vc.detailType = CZDChoiceDetailControllerDiscover;
        } else if (self.type == CZDChoicenessControllerTypeEvaluation){
            vc.detailType = CZDChoiceDetailControllerEvaluation;
        } else {
            
        }
        vc.findgoodsId = model.articleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.type == CZDChoicenessControllerTypeDiscover) {
        NSString *OneControllerScrollViewDidScroll = @"CZSearchSubDetailOneController";
        [[NSNotificationCenter defaultCenter] postNotificationName:OneControllerScrollViewDidScroll object:nil userInfo:@{@"scrollView" : scrollView}];
    }
}
@end
