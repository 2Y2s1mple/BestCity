//
//  CZBaseRecommendController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/8.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZBaseRecommendController.h"
#import "CZHotSaleCell.h"
#import "CZRecommendDetailController.h"


@interface CZBaseRecommendController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CZBaseRecommendController

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
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
    CZRecommendListModel *model = self.dataSource[indexPath.row];
    CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
    vc.goodsId = model.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
