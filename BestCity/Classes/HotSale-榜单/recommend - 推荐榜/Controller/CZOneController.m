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

@interface CZOneController ()

@end

@implementation CZOneController

- (void)getDataSource
{
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/goodsRankList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"list"]];
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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //line
    CZTOPLINE;
    [CZRecommendListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"goodsScopeList" : @"CZHotScoreModel"
                 };
    }];
    
    self.tableView.frame = CGRectMake(0, 10, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 54 : 30) + (IsiPhoneX ? 83 : 49) + 94));
    self.tableView.tableHeaderView = [self setupHeaderView];
    // 创建刷新控件
    [self setupRefresh];
    
    // 判断是否更新
    [self isNeedUpdate];
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

- (UIView *)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 180)];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"banner"]];
    imageView.frame = CGRectMake(10, 10, SCR_WIDTH - 20, backView.height - 10);
    [backView addSubview:imageView];
    
    return backView;
}



@end
