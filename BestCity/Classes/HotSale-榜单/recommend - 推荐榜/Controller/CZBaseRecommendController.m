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
#import "CZEndLineView.h"

@interface CZBaseRecommendController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CZBaseRecommendController

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
    tableView.tableFooterView = [self creatFooterView];
    self.tableView = tableView;
}

- (UIView *)creatFooterView
{
    CZEndLineView *footer = [CZEndLineView endLineView];
    footer.autoresizingMask = UIViewAutoresizingNone;
    return footer;
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
    if ([USERINFO[@"userId"] length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {    
        CZRecommendListModel *model = self.dataSource[indexPath.row];
        CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}

@end
