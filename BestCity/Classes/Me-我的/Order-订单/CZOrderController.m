//
//  CZOrderController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZOrderController.h"
#import "CZNavigationView.h"
#import "CZOrderListCell.h"
#import "GXNetTool.h"
#import "CZOrderModel.h"
#import "CZMeController.h"
#import "CZOrderDetailController.h" //详情



@interface CZOrderController () <UITableViewDelegate, UITableViewDataSource, CZNavigationViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *roderArray;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@end

@implementation CZOrderController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noOrderView];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = 180;
        self.noDataView.backgroundColor = [UIColor clearColor];
    }
    return _noDataView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, SCR_HEIGHT - 68 - (IsiPhoneX ? 24 : 0)) style:UITableViewStylePlain];
        _tableView.backgroundColor = CZGlobalLightGray;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我的订单" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    navigationView.delegate = self;
    [self.view addSubview:navigationView];
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    
    
    // 创建类表
    [self.view addSubview:self.tableView];
    [self getDataSource];
}

#pragma mark - <CZNavigationViewDelegate>
- (void)popViewController
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[CZMeController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)getDataSource
{
    [CZOrderModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                    @"orderId" : @"id"
                 };
    }];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/order/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
            if ([result[@"data"] count] > 0) {
                self.tableView.backgroundColor = CZGlobalLightGray;
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                self.tableView.backgroundColor = CZGlobalWhiteBg;
                // 加载NnoData图片
                [self.tableView addSubview:self.noDataView];
            }
            self.roderArray = [CZOrderModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.tableView reloadData];
            
        } 
    } failure:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZOrderListCell *cell = [CZOrderListCell cellWithTableView:tableView];
    cell.model = self.roderArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZOrderModel *model = self.roderArray[indexPath.row];
    
    return model.heightCell;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZOrderModel *model = self.roderArray[indexPath.row];
    CZOrderDetailController *vc = [[CZOrderDetailController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
