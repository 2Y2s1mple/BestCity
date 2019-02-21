//
//  CZTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTwoController.h"
#import "CZHotSaleCell.h"
#import "CZHotTitleModel.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CZSubButton.h"
#import "CZHotListController.h"
#import "CZAllHotListController.h"


@interface CZTwoController ()

/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZTwoController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 180;
    }
    return _noDataView;
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    
    // 设置tableView
    self.tableView.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + (IsiPhoneX ? 83 : 49) + 94) + 50);
    if (!self.isAllHotList) {    
        // 设置头部标题
        self.tableView.tableHeaderView = [self setupHeaderView]; 
    } 
    // 加载刷新控件
    [self setupRefresh];
}

#pragma mark - 网络请求
- (void)getDataSource
{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"page"] = @"0";
        param[@"category1Id"] = self.subTitles.categoryId;
        param[@"client"] = @(2);
        
        [CZProgressHUD showProgressHUDWithText:nil];
        //获取数据
        [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                if ([result[@"data"] count] > 0) {
                    // 删除noData图片
                    [self.noDataView removeFromSuperview];
                    self.tableView.tableFooterView = [self creatFooterView];;
                } else {
                    // 加载NnoData图片
                    [self.tableView addSubview:self.noDataView];
                    self.tableView.tableFooterView = nil;
                }
                self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"data"]];
                [self.tableView reloadData];
            }
            //隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            
        } failure:^(NSError *error) {
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
        }];
}

- (void)getHotList2Data
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @"0";
    param[@"category2Id"] = self.subTitles.children[self.index - 1].categoryId;
    param[@"orderbyType"] = @(0);
    param[@"client"] = @(2);
    
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsList2"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
                self.tableView.tableFooterView = [self creatFooterView];;
            } else {
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
                self.tableView.tableFooterView = nil;
            }
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.tableView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 初始化视图
- (UIView *)setupHeaderView
{
    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 90)];
    backView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:backView];
    NSArray *children;
    if (self.subTitles.children.count >= 10) {
        children = [self.subTitles.children subarrayWithRange:NSMakeRange(0, 10)];
    } else {
        children = self.subTitles.children;
    }
    
    CGFloat space = (SCR_WIDTH - 20 - 5 * 55) / 4;
    CGFloat w = 55;
    CGFloat h = w + 20;
    NSInteger cols = 5;
    for (int i = 0; i < children.count; i++) {
        CZHotSubTilteModel *model = children[i];
        NSInteger col = i % cols; 
        NSInteger row = i / cols;
        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = w;
        btn.height = h;
        btn.x = 10 + col * (w + space);
        btn.y = 12 + row * (h + 10);
        [btn setTitle:i == 9 ? @"查看全部" : model.categoryName forState:UIControlStateNormal];
        if (i == 9) {
            [btn setImage:[UIImage imageNamed:@"pic-all"] forState:UIControlStateNormal];
        } else {        
            [btn sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal];
        }
        [backView addSubview:btn];
        // 点击事件
        [btn addTarget:self action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        backView.height = CZGetY(btn);
    }
    return backView;
}

/**
 * 头部的大图片
 */
- (UIView *)headerView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 180)];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"banner"]];
    imageView.frame = CGRectMake(10, 10, SCR_WIDTH - 20, backView.height - 10);
    [backView addSubview:imageView];
    return backView;
}

/**
 * 加载刷新视图
 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 事件
- (void)didClickedBtn:(UIButton *)sender
{
    if ((sender.tag - 100) == 9) {
        CZAllHotListController *hotVc = [[CZAllHotListController alloc] init];
        [hotVc setUpPorperty];
        hotVc.subTitlesModel = self.subTitles;
        [hotVc reloadData];
        hotVc.menuView.backgroundColor = CZGlobalLightGray;
        [self.navigationController pushViewController:hotVc animated:YES];
    } else {
        CZHotListController *hotVc = [[CZHotListController alloc] init];
        [hotVc setUpPorperty];
        NSMutableArray *subTitles = [NSMutableArray array];
        NSArray *titles = @[@"综合榜", @"热卖榜", @"轻奢榜", @"新品榜", @"性价比榜"];
        CZHotSubTilteModel *model = self.subTitles.children[sender.tag - 100];
        hotVc.mainTitle = model.categoryName;
        for (int i = 0; i < titles.count; i++) {    
            CZHotTitleModel *titleModel = [[CZHotTitleModel alloc] init];
            titleModel.categoryId = model.categoryId;
            titleModel.categoryName = titles[i];
            [subTitles addObject:titleModel];
        }
        hotVc.subTitles = subTitles;
        hotVc.isList2 = YES;
        [hotVc reloadData];
        [self.navigationController pushViewController:hotVc animated:YES];
    }   
}

- (void)loadNewData
{
    if (self.index != 0) {
        [self getHotList2Data];
    } else {
        //获取数据
        [self getDataSource];
    }
}

#pragma mark - 代理方法
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *OneControllerScrollViewDidScroll = @"CZOneControllerScrollViewDidScroll";
    [[NSNotificationCenter defaultCenter] postNotificationName:OneControllerScrollViewDidScroll object:nil userInfo:@{@"scrollView" : scrollView}];
}
@end
