//
//  CZSubFreeChargeController.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZSubFreeChargeController.h"
#import "CZFreeChargeCell3.h"
#import "CZFreeChargeCell4.h"
#import "UIButton+CZExtension.h" // 按钮扩展

@interface CZSubFreeChargeController ()
/** 返回键 */
@property (nonatomic, strong) UIButton *popButton;
@end

@implementation CZSubFreeChargeController
- (UIButton *)popButton
{
    if (_popButton == nil) {
        _popButton = [UIButton buttonWithFrame:CGRectMake(14, (IsiPhoneX ? 54 : 30), 30, 30) backImage:@"nav-back" target:self action:@selector(popAction)];
//        _popButton.backgroundColor = [UIColor colorWithRed:21/255.0 green:21/255.0 blue:21/255.0 alpha:0.3];
//        _popButton.layer.cornerRadius = 15;
//        _popButton.layer.masksToBounds = YES;
    }
    return _popButton;
}

#pragma mark - 事件
// 返回
- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 34 : 0));
    [self.view addSubview:self.popButton];
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @( self.page);
    param[@"type"] = @(0);

    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/free/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.freeChargeDatas = [NSMutableArray arrayWithArray: result[@"data"]];
            [self.tableView reloadData];
            // 结束刷新
        }
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)reloadMoreTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    param[@"type"] = @(0);

    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/free/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *arr = result[@"data"];
            [self.freeChargeDatas addObjectsFromArray:arr];
            [self.tableView reloadData];
            if (arr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            [self.tableView.mj_footer endRefreshing];
        }

    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CZFreeChargeCell3 *cell = [CZFreeChargeCell3 cellWithTableView:tableView];
//            cell.model = self.freeChargeDatas[indexPath.row];
        return cell;
    } else {
        CZFreeChargeCell4 *cell = [CZFreeChargeCell4 cellWithTableView:tableView];
        cell.model = self.freeChargeDatas[indexPath.row - 1];
        return cell;
    }
}
@end
