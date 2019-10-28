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
/** <#注释#> */
@property (nonatomic, assign) NSInteger recordIndex;
/** <#注释#> */
@property (nonatomic, assign) BOOL isShowAll;

@end

@implementation CZMHSDetailCommodity
#pragma mark - 视图
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.size = CGSizeMake(self.view.width, self.view.height);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self tableViewHeaderView:0 showAll:NO];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)tableViewHeaderView:(NSInteger)index showAll:(BOOL)isShow
{
    if ([self.model.relatedItemList[index][@"introduction"] length] < 1) {
        return nil;
    }
    self.recordIndex = index;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllTableViewHeaderView)];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:tap];


    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.model.relatedItemList[index][@"introductionTitle"];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
    titleLabel.textColor = [UIColor colorWithRed:86/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    [titleLabel sizeToFit];
    titleLabel.x = 15;
    titleLabel.y = 5;
    [backView addSubview:titleLabel];

    UILabel *content = [[UILabel alloc] init];
//    content.backgroundColor = RANDOMCOLOR;
    content.text = self.model.relatedItemList[index][@"introduction"];
    content.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
    content.textColor = [UIColor colorWithRed:86/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
    content.numberOfLines = 0;
    content.width = SCR_WIDTH - 30;
    CGRect rect = [content.text boundingRectWithSize:CGSizeMake(content.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : content.font} context:nil];

    content.x = 15;
    content.y = 28;
    content.height = rect.size.height;
    NSInteger count = (NSInteger)(rect.size.height) / content.font.lineHeight;
    NSLog(@"%ld", count);
    [backView addSubview:content];
    if (count > 3 && !isShow) {
        content.numberOfLines = 3;
        content.height = 3 * content.font.lineHeight;
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowBtn.userInteractionEnabled = NO;
//        [arrowBtn addTarget:self action:@selector(showAllTableViewHeaderView:) forControlEvents:UIControlEventTouchUpInside];
        [arrowBtn setImage:[UIImage imageNamed:@"list-right-4"] forState:UIControlStateNormal];
        [backView addSubview:arrowBtn];
        [arrowBtn sizeToFit];
        arrowBtn.centerX = SCR_WIDTH / 2.0;
        arrowBtn.y = CZGetY(content);
        backView.height = CZGetY(content) + 22;
    } else if (count > 3) {
        content.numberOfLines = 0;
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowBtn.userInteractionEnabled = NO;
//        [arrowBtn addTarget:self action:@selector(showAllTableViewHeaderView:) forControlEvents:UIControlEventTouchUpInside];
        [arrowBtn setImage:[UIImage imageNamed:@"list-right-5"] forState:UIControlStateNormal];
        [backView addSubview:arrowBtn];
        [arrowBtn sizeToFit];
        arrowBtn.centerX = SCR_WIDTH / 2.0;
        arrowBtn.y = CZGetY(content);
        backView.height = CZGetY(content) + 22;
    } else {
        backView.height = CZGetY(content) + 5;
    }

    return backView;
}

#pragma mark - 事件
- (void)showAllTableViewHeaderView
{

    if (self.isShowAll) {
        _tableView.tableHeaderView = [self tableViewHeaderView:self.recordIndex showAll:NO];
        self.isShowAll = NO;
    } else {
        _tableView.tableHeaderView = [self tableViewHeaderView:self.recordIndex showAll:YES];
        self.isShowAll = YES;
    }
}

// 每次点击item都会调用
- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex
{
    // 每次调用都重新创建新的View, 这个不好, 以后要重写
    _tableView.tableHeaderView = [self tableViewHeaderView:selectedItemIndex showAll:NO];
    self.isShowAll = NO;

}

- (void)setTopDataList:(NSArray *)topDataList
{
    _topDataList = topDataList;
    self.model.relatedGoodsList = topDataList;
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
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
