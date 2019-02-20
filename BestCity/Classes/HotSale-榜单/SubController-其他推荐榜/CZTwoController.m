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
    
    // 设置头部标题
    self.tableView.tableHeaderView = [self setupHeaderView]; 
    
    // 加载刷新控件
    [self setupRefresh];
    
    //获取数据
    [self getDataSource];
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

#pragma mark - 初始化视图
- (UIView *)setupHeaderView
{
    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 90)];
    backView.showsHorizontalScrollIndicator = NO;
    backView.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:backView];
    //    NSArray *titles = @[@"剃须刀", @"计步器", @"吹风机", @"足浴盆", @"体重计", @"剃/脱毛器", @"美容仪", @"按摩椅", @"理发器", @"电动牙刷"];
    CGFloat space = (SCR_WIDTH - 20 - 5 * 55) / 4;
    CGFloat w = 55;
    CGFloat h = w + 20;
    
    for (int i = 0; i < self.subTitles.children.count; i++) {
        CZHotSubTilteModel *model = self.subTitles.children[i];
        // 创建按钮
        CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.width = w;
        btn.height = h;
        
        if (i > 4) {
            btn.x = 10 + (i - 5) * (w + space);
            btn.y = 12 + h + 10;
            backView.height = 180;
        } else {
            btn.x = 10 + i * (w + space);
            btn.y = 12;
        }
        [btn sd_setImageWithURL:[NSURL URLWithString:model.img] forState:UIControlStateNormal];
        
        [btn setTitle:model.categoryName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [backView addSubview:btn];
        
        // 点击事件
        [btn addTarget:self action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
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
}

#pragma mark - 事件
- (void)didClickedBtn:(UIButton *)sender
{
    CZHotListController *hotVc = [[CZHotListController alloc] init];
    hotVc.selectIndex = 0;
    hotVc.menuViewStyle = WMMenuViewStyleLine;
    hotVc.itemMargin = 10;
    hotVc.progressHeight = 3;
    hotVc.automaticallyCalculatesItemWidths = YES;
    hotVc.titleFontName = @"PingFangSC-Medium";
    hotVc.titleColorNormal = CZGlobalGray;
    hotVc.titleColorSelected = CZRGBColor(5, 5, 5);
    hotVc.titleSizeNormal = 15.0f;
    hotVc.titleSizeSelected = 15;
    hotVc.progressColor = CZREDCOLOR;
    
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
    
    NSLog(@"didClickedBtn --- %@", model.categoryName);
    
    [self.navigationController pushViewController:hotVc animated:YES];
}

- (void)loadNewData
{
    //获取数据
    [self getDataSource];
}

#pragma mark - 代理方法
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *OneControllerScrollViewDidScroll = @"CZOneControllerScrollViewDidScroll";
    [[NSNotificationCenter defaultCenter] postNotificationName:OneControllerScrollViewDidScroll object:nil userInfo:@{@"scrollView" : scrollView}];
}
@end
