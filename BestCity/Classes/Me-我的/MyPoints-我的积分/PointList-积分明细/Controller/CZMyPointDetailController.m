//
//  CZMyPointDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMyPointDetailController.h"
#import "CZNavigationView.h"
#import "CZMyPointDetailCell.h"
#import "GXNetTool.h"
#import "MJExtension.h"
#import "CZPointDetailModel.h"

@interface CZMyPointDetailController ()<UITableViewDelegate , UITableViewDataSource>
/** 详情数组 */
@property (nonatomic, strong) NSArray *detailsArr;
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZMyPointDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"积分明细" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCR_WIDTH, SCR_HEIGHT - 68) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    // 加载数据
    [self getDataSource];
}

#pragma mark - 获得数据
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/pointDetail"];
    // 请求
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 赋值
            self.detailsArr = [CZPointDetailModel objectArrayWithKeyValuesArray:result[@"pointDetailList"]];
            [self.tableView reloadData];
            // 隐藏菊花
            [CZProgressHUD hideAfterDelay:0];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"无数据"];
            [CZProgressHUD hideAfterDelay:2];
        }
        
    } failure:^(NSError *error) {
        // 隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMyPointDetailCell *cell = [CZMyPointDetailCell cellWithTabelView:tableView];
    cell.model = self.detailsArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

@end
