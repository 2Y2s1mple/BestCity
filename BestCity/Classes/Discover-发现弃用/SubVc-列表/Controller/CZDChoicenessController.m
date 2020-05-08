//
//  CZDChoicenessController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDChoicenessController.h"
#import "CZDChoiceDetailController.h"

#import "CZDiscoverDetailModel.h"

#import "CZChoicenessCell.h"

#import "GXNetTool.h"
#import "CZScollerImageTool.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"


@interface CZDChoicenessController ()<UITableViewDelegate, UITableViewDataSource>
/** tabelview */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZDChoicenessController
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
    self.page = 1;
    self.view.backgroundColor = CZGlobalWhiteBg;
    //line
    CZTOPLINE;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, 0) style:UITableViewStylePlain];
    if (self.type == CZJIPINModuleDiscover) {
        self.tableView.height = SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + 84 + (IsiPhoneX ? 83 : 49)) + 50;
    } else {
        self.tableView.height = SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + HOTTitleH) - (IsiPhoneX ? 83 : 49);
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self setupHeaderView];
    
    //创建刷新控件
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDiscover)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

- (UIView *)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 170)];
    // 创建轮播图
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, backView.height)];
    [backView addSubview:imageView];
    imageView.imgList = self.imageUrlList;
    return backView;
}

#pragma mark - 加载第一页
- (void)reloadNewDiscover
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"categoryId"] = self.titleID;
    param[@"page"] = @(self.page);
    [CZProgressHUD showProgressHUDWithText:nil];
    NSString *path;
    if (self.type == CZJIPINModuleDiscover) {
        path = @"api/found/list"; // 发现
    } else {
        path = @"api/evaluation/list"; // 测评
    }
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:path] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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
    param[@"categoryId"] = self.titleID;
    param[@"page"] = @(self.page);
    [CZProgressHUD showProgressHUDWithText:nil];
    NSString *path;
    if (self.type == CZJIPINModuleDiscover) {
        path = @"api/found/list"; // 发现
    } else {
        path = @"api/evaluation/list"; // 测评
    }
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:path] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
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
    if (self.type == CZJIPINModuleDiscover) {
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
//    if ([JPTOKEN length] <= 0)
//    {
//        CZLoginController *vc = [CZLoginController shareLoginController];
//        [self presentViewController:vc animated:YES completion:nil];
//    } else {
        CZDiscoverDetailModel *model = self.dataSource[indexPath.row];
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = self.type;
        vc.findgoodsId = model.articleId;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.type == CZJIPINModuleDiscover) {
        NSString *OneControllerScrollViewDidScroll = @"CZOneControllerScrollViewDidScroll";
        [[NSNotificationCenter defaultCenter] postNotificationName:OneControllerScrollViewDidScroll object:nil userInfo:@{@"scrollView" : scrollView}];
    }
    
}



@end
