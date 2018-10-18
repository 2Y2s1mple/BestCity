//
//  CZUseController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZUseController.h"
#import "CZDiscountCouponCell.h"

@interface CZUseController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CZUseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, self.view.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDiscountCouponCell *cell = [CZDiscountCouponCell cellWithTabelView:tableView];
    cell.type = CZDiscountCouponCellTypeUsed;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

@end
