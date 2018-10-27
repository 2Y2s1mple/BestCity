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

@interface CZOneController ()<UITableViewDelegate, UITableViewDataSource>
/** 当前数据 */
@property (nonatomic, strong) NSArray *dataSource;
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCR_WIDTH, SCR_HEIGHT - HOTContentY - 49 - 10) style:UITableViewStylePlain];
     if (@available(iOS 11.0, *)) {
         tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.tableHeaderView = [self setupHeaderView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource[indexPath.row] cellHeight];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"hotSaleCell";
    CZHotSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZHotSaleCell class]) owner:nil options:nil] lastObject];
    }
    
    CZRecommendListModel *model = self.dataSource[indexPath.row];
    model.indexNumber = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
    CZOneDetailController *vc = [[CZOneDetailController alloc] init];
    vc.selectIndex = 0;
    vc.menuViewStyle = WMMenuViewStyleLine;
    vc.automaticallyCalculatesItemWidths = YES;
    //        hotVc.titleFontName = @"PingFangSC-Medium";
    vc.titleColorNormal = CZGlobalGray;
    vc.titleColorSelected = CZRGBColor(5, 5, 5);
    vc.titleSizeNormal = 16.0f;
    vc.titleSizeSelected = vc.titleSizeNormal;
    vc.progressColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}


@end
