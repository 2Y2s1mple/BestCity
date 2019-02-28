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

@interface CZOneController ()
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
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
    param[@"client"] = @(2);
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getTopGoodsList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"data"]];
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
    self.tableView.tableHeaderView = [self setupHeaderView];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @(0);
    param[@"clientVersionCode"] = @"1.00";
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getAppVersion"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSNumber *appVersion1 = result[@"data"][@"open"];
            if (![appVersion1 isEqual:@(0)]) {} else {}
            //有新版本
            [CZSaveTool setObject:result[@"data"] forKey:requiredVersionCode];
            // 判断是否更新
            [self isNeedUpdate];
        }
    } failure:^(NSError *error) {}];
    // 创建刷新控件
    [self setupRefresh];
}

- (void)isNeedUpdate
{
    NSDictionary *versionContrl = [CZSaveTool objectForKey:requiredVersionCode];
    if (![versionContrl[@"needUpdate"] isEqual:@(0)]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本%@",versionContrl[@"versionName"]] message:versionContrl[@"content"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction * update = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转到App Store
            NSString *urlStr = [NSString stringWithFormat:@"%@",versionContrl[@"downloadUrl"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }];
        [alert addAction:ok];
        [alert addAction:update];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"banner"]];
    imageView.frame = CGRectMake(10, 10, SCR_WIDTH - 20, 157);
    [backView addSubview:imageView];
    return backView;
}


@end
