//
//  CZMyWalletDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletDetailController.h"
#import "CZNavigationView.h"
#import "CZMyWalletModel.h"
#import "CZMyWalletDetailCell.h"

@interface CZMyWalletDetailController ()<UITableViewDelegate, UITableViewDataSource>

/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZMyWalletDetailController
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(14, ((IsiPhoneX ? 24 : 0) + 67.7), SCR_WIDTH - 28, SCR_HEIGHT - ((IsiPhoneX ? 24 : 0) + 67.7)) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = CZGlobalLightGray;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalLightGray;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"收入明细" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];

    [self.view addSubview:self.tableView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:self.index];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CZMyWalletModel *model = self.detailList[section];
    UIView *view = [[UIView alloc] init];
    view.x = 14;
    view.width = SCR_WIDTH - 28;
    view.backgroundColor = CZGlobalLightGray;
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@-%@", model.year, model.month];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    label.x = 14;
    label.centerY = 43 / 2.0;
    [view addSubview:label];
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = [NSString stringWithFormat:@"¥%.2lf", [model.totalPreFee floatValue]];;
    label2.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    label2.textColor = CZREDCOLOR;
    [label2 sizeToFit];
    label2.x = view.width - 14 - label2.width;
    label2.centerY = label.centerY;
    [view addSubview:label2];

    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"预估收益";
    label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    label1.textColor = [UIColor blackColor];
    [label1 sizeToFit];
    label1.x = view.width - label1.width - label1.width - 14;
    label1.centerY = label.centerY;
    [view addSubview:label1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    return footer;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detailList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.detailList[section] commissionDetailList] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMyWalletDetailCell *cell = [CZMyWalletDetailCell cellWithTabelView:tableView];
    cell.model = [self.detailList[indexPath.section] commissionDetailList][indexPath.row];
    return cell;
}



@end
