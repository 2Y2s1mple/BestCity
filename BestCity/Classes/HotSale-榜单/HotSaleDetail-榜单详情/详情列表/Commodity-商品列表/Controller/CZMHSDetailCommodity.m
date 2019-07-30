//
//  CZMHSDetailCommodity.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMHSDetailCommodity.h"
#import "CZMHSDCommodityCell.h"
#import "CZMHSDCommodityCell1.h"
#import "CZMHSDCommodityCell2.h"
#import "CZMHSDCommodityCell3.h"

// 详情
#import "CZDChoiceDetailController.h"
#import "CZRecommendDetailController.h"

@interface CZMHSDetailCommodity () <UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CZMHSDetailCommodity
#pragma mark - 视图
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.size = CGSizeMake(self.view.width, self.view.height);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - 数据
- (void)setTopDataList:(NSArray *)topDataList
{
    _topDataList = topDataList;
    self.model.relatedGoodsList = topDataList;
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    });
}


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.size = CGSizeMake(self.view.width, self.view.height);

}

#pragma mark - 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160;
    } else if (indexPath.section == 1) {
        return 449;
    } else if (indexPath.section == 2)  {
        return 290;
    } else {
        if (indexPath.row == 0) {
            return 184;
        } else {
            return 150;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.model.relatedGoodsList.count;;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.model.relatedItemCategotyList.count;
    } else {
        return self.model.relatedArticleList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CZMHSDCommodityCell *cell = [CZMHSDCommodityCell cellwithTableView:tableView];
        cell.dataDic = self.model.relatedGoodsList[indexPath.row];
        cell.indexNumber = indexPath.row;
        return cell;
    } else if (indexPath.section == 1) {
        CZMHSDCommodityCell1 *cell = [CZMHSDCommodityCell1 cellwithTableView:tableView];
        cell.ID = self.ID;
        cell.titleText = self.model.categoryName;
        cell.dataList = self.model.relatedQuestionList;
        cell.bkDataDic = self.model.relatedPedia;
        return cell;
    } else if (indexPath.section == 2)  {
        CZMHSDCommodityCell2 *cell = [CZMHSDCommodityCell2 cellwithTableView:tableView];
        cell.dataDic = self.model.relatedItemCategotyList[indexPath.row];
        return cell;
    } else {
        CZMHSDCommodityCell3 *cell = [CZMHSDCommodityCell3 cellwithTableView:tableView];
        cell.ID = self.ID;
        cell.titleText = [NSString stringWithFormat:@"%@评测推荐", self.model.categoryName];
        cell.dataDic = self.model.relatedArticleList[indexPath.row];
        if (indexPath.row == 0) {
            cell.isFirstOne = YES;
        } else {
            cell.isFirstOne = NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ISPUSHLOGIN;
    if (indexPath.section == 0) {
        NSDictionary *model = self.model.relatedGoodsList[indexPath.row];
        CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
        vc.goodsId = model[@"goodsId"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {

    } else if (indexPath.section == 2)  {

    } else {
        NSDictionary *model = self.model.relatedArticleList[indexPath.row];
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = CZJIPINModuleEvaluation;
        vc.findgoodsId = model[@"articleId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
