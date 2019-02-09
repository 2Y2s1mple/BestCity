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
#import "CZSubTitleButton.h"
#import "TSLWebViewController.h"
#import "UIImageView+WebCache.h"

@interface CZTwoController ()
/** 记录高度 */
@property (nonatomic, assign) CGFloat recordHeight;
/** 记录点击的按钮 */
@property (nonatomic, strong) UIButton *recordBtn;
/** 记录Id避免重复点击刷新 */
@property (nonatomic, strong) NSString *recordID;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *param;
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
    
    // 设置头部标题
    [self setupHeaderView];
    
    // 设置tableView
    self.tableView.frame = CGRectMake(0, 40, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + (IsiPhoneX ? 83 : 49) + 94) - 40 + 50);
    self.tableView.tableHeaderView = [self headerView];
    
    // 加载刷新控件
    [self setupRefresh];
    
    //获取标题1的数据
    [self getDataSourceWithId:self.subTitles[0].categoryId];
}

#pragma mark - 网络请求
- (void)getDataSourceWithId:(NSString *)SourceId
{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"page"] = @"0";
        param[@"category2Id"] = SourceId;
        param[@"client"] = @(2);
        self.param = param;
        
        [CZProgressHUD showProgressHUDWithText:nil];
        //获取数据
        [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/goodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            NSLog(@"记录%@\n最新%@", self.param, param);
            if (self.param != param) return ;
            
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
        self.recordID = SourceId;
}




#pragma mark - 初始化视图
- (void)setupHeaderView
{
    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 40)];
    backView.showsHorizontalScrollIndicator = NO;
    backView.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:backView];
    //    NSArray *titles = @[@"剃须刀", @"计步器", @"吹风机", @"足浴盆", @"体重计", @"剃/脱毛器", @"美容仪", @"按摩椅", @"理发器", @"电动牙刷"];
    CGFloat space = 8;
    CGFloat h = 40;
    for (int i = 0; i < self.subTitles.count; i++) {
        // 创建按钮
        CZSubTitleButton *btn = [CZSubTitleButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = RANDOMCOLOR;
        // 设置模型
        CZHotSubTilteModel *model = self.subTitles[i];
        model.indexBtn = i;
        btn.model = model;
        [btn sizeToFit];
        
        // 添加监听
        [btn addTarget:self action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            _recordBtn = btn;
            btn.x = space;
            btn.y = 0;
            btn.height = h;
        } else {
            CGFloat leftSpace = CZGetX(backView.subviews[i - 1]) + space;
            btn.x = leftSpace;
            btn.y = backView.subviews[i - 1].y;
            btn.height = h;
        }
        [backView addSubview:btn];
        _recordHeight = CZGetX(btn);
    }
    backView.contentSize = CGSizeMake(_recordHeight + 10, 0);
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
- (void)didClickedBtn:(CZSubTitleButton *)sender
{
    _recordBtn.selected = NO;
    sender.selected = YES;
    // 获取点击数据
    if (self.recordID != sender.model.categoryId) {
        [self getDataSourceWithId:sender.model.categoryId];
    }
    _recordBtn = sender;
}

- (void)loadNewData
{
    [self getDataSourceWithId:self.recordID];
}

#pragma mark - 代理方法
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *OneControllerScrollViewDidScroll = @"CZOneControllerScrollViewDidScroll";
    [[NSNotificationCenter defaultCenter] postNotificationName:OneControllerScrollViewDidScroll object:nil userInfo:@{@"scrollView" : scrollView}];
}
@end
