//
//  CZOneController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZOneController.h"
#import "CZHotSaleCell.h"
#import "CZOneDetailController.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"
#import "CZRecommendListModel.h"
#import "MJExtension.h"

@interface CZOneController ()

@end

@implementation CZOneController

- (void)getDataSource
{
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/goodsRankList"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        NSLog(@"-----------");
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.tableView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
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
    // 获取数据
    [self getDataSource];
    
    self.tableView.frame = CGRectMake(0, 10, SCR_WIDTH, SCR_HEIGHT - HOTContentY - 49 - 10);
    self.tableView.tableHeaderView = [self setupHeaderView];
}

- (UIView *)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, FSS(180))];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"banner"]];
    imageView.frame = CGRectMake(10, 10, SCR_WIDTH - 20, backView.height - 10);
    [backView addSubview:imageView];
    
    return backView;
}

@end
