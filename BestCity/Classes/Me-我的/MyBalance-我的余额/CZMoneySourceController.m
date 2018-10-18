//
//  CZMoneySourceController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMoneySourceController.h"
#import "CZNavigationView.h"
#import "CZMoneySourceCell.h"

@interface CZMoneySourceController ()<UITableViewDelegate, UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZMoneySourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"佣金来源" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCR_WIDTH, SCR_HEIGHT - 68) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMoneySourceCell *cell = [CZMoneySourceCell cellWithTableView:tableView];
    
//    cell.layer.borderWidth = 1;
//    cell.layer.borderColor = 
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}








@end
