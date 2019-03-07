//
//  CZAddressController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAddressController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZAddressModel.h"
#import "CZAddressCell.h"
#import "CZEditAddressController.h"

@interface CZAddressController ()<UITableViewDelegate, UITableViewDataSource>
/** 类表 */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *addressArray;
@end

@implementation CZAddressController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, SCR_HEIGHT - 68 - (IsiPhoneX ? 24 : 0)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    [CZAddressModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"addressId" : @"id"
                 };
    }];
    
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"收货地址" rightBtnTitle:@"新增地址" rightBtnAction:^{
        CZEditAddressController *vc = [[CZEditAddressController alloc] init];
        vc.currnetTitle = @"新增地址";
        [self.navigationController pushViewController:vc animated:YES];
    } navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    // 添加列表
    [self.view addSubview:self.tableView];
}

- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/address/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
            self.addressArray = [CZAddressModel objectArrayWithKeyValuesArray:result[@"data"]];
            
            [CZProgressHUD hideAfterDelay:1];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZAddressCell *cell = [CZAddressCell cellWithTableView:tableView];
    cell.addressModel = self.addressArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 136;
}


@end
