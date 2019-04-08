//
//  CZCommonRecommendController.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCommonRecommendController.h"
#import "CZCommonRecommendCell.h"
// 跳转
#import "CZRecommendDetailController.h"
#import "CZDChoiceDetailController.h"


@interface CZCommonRecommendController () <UITableViewDelegate, UITableViewDataSource>
/** 表 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZCommonRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setArticleArr:(NSArray *)articleArr
{
    _articleArr = articleArr;
    [self setup];
    self.tableView.height = 146 * articleArr.count;
    self.view.height = CZGetY([self.view.subviews lastObject]) + 50; 
}

- (void)setup
{
    CGFloat space = 14.0f;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 20, 150, 20)];
    titleLabel.text = @"相关推荐";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [self.view addSubview:titleLabel];
    
    if (self.articleArr.count > 0) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(titleLabel.x, CZGetY(titleLabel), SCR_WIDTH - 2 * titleLabel.x, 200) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView = tableView;
    } else {
        UIView *contentView = [[UIView alloc] init];
        contentView.x = 0;
        contentView.y = CZGetY(titleLabel);
        contentView.width = SCR_WIDTH;
        contentView.height = 170;
        [self.view addSubview:contentView];
        UILabel *title = [[UILabel alloc] init];
        title.text = @"暂无相关推荐";
        title.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        title.textColor = CZGlobalGray;
        [title sizeToFit];
        title.center = CGPointMake(contentView.width / 2.0, contentView.height / 2.0);
        [contentView addSubview:title];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZCommonRecommendCell *cell = [CZCommonRecommendCell cellWithTableView:tableView];
    cell.dataDic = self.articleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.articleArr[indexPath.row];
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    vc.findgoodsId = model[@"articleId"];
    if ([model[@"type"]  isEqual: @(2)]) {
        vc.detailType = CZJIPINModuleEvaluation;
    } else if ([model[@"type"]  isEqual: @(3)]) {
        vc.detailType = CZJIPINModuleDiscover;
    } else if ([model[@"type"]  isEqual: @(4)]) {
        vc.detailType = CZJIPINModuleTrail;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
