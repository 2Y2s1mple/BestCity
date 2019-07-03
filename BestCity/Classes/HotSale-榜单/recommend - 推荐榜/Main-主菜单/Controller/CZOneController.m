//
//  CZOneController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZOneController.h"
#import "CZHotSaleCell.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"
#import "CZRecommendListModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CZSubButton.h"
#import "CZScollerImageTool.h"
#import "CZUpdataView.h"

@interface CZOneController ()
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
/** 轮播图 */
@property (nonatomic, strong) NSMutableArray *imageUrlList;
@end

@implementation CZOneController
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

#pragma mark - 获取数据
- (void)getDataSource
{
    [CZProgressHUD showProgressHUDWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getTopGoodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"data"]];
            self.imageUrlList = [NSMutableArray array];
            for (NSDictionary *dic in result[@"adList"] ) {
                [self.imageUrlList addObject:dic[@"img"]];
            }
            self.tableView.tableHeaderView = [self setupHeaderView];
            [self.tableView reloadData];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark -控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    
    self.tableView.frame = CGRectMake(0, 10, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + (IsiPhoneX ? 83 : 49) + 94));
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"0";
    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    param[@"clientVersionCode"] = curVersion;
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getAppVersion"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSNumber *appVersion1 = result[@"data"][@"open"];
            if (![appVersion1 isEqual:@(0)]) {} else {}
            //有新版本
            [CZSaveTool setObject:result[@"data"] forKey:requiredVersionCode];
            //比较
            if ([curVersion compare:result[@"data"][@"versionCode"]] == NSOrderedAscending && [result[@"data"][@"open"] isEqualToNumber:@(1)]) {
                // 判断是否更新
                CZUpdataView *backView = [CZUpdataView updataView];
                backView.versionMessage = result[@"data"];
                backView.frame = [UIScreen mainScreen].bounds;
                backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                [[UIApplication sharedApplication].keyWindow addSubview: backView];
            } 
        }
    } failure:^(NSError *error) {}];
    // 创建刷新控件
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData
{
    [self getDataSource];
}

#pragma mark - 创建头视图
- (UIView *)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 167)];
    
    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(10, 10, SCR_WIDTH - 20, 157)];
    [backView addSubview:imageView];
    imageView.imgList = self.imageUrlList;
    [backView addSubview:imageView];     
    return backView;
}


@end
