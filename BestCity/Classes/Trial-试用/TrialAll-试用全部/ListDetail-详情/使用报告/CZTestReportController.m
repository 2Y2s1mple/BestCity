//
//  CZTestReportController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTestReportController.h"
//模型
#import "CZTrailReportModel.h"
//视图
#import "CZTrialReportMainCell.h"
#import "CZMutContentButton.h"
// 详情
#import "CZDChoiceDetailController.h"
#import "CZTrialAllReportHotController.h"

static CGFloat cellHeight = 124;


@interface CZTestReportController () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 报告 */
@property (nonatomic, assign) NSInteger listCount;

@end

@implementation CZTestReportController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 200) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTopView];
    CGFloat tableViewHeight = SCR_HEIGHT - ((IsiPhoneX ? 44 + 40 : 20 + 40) + 49 + 60);
    if (self.listCount == 0) {    
        self.view.x = 0;
        self.view.width = SCR_WIDTH;
        self.view.height = tableViewHeight;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"暂无试用报告";
        titleLabel.textColor = CZGlobalGray;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(self.view.width / 2.0, self.view.height / 2.0);
        [self.view addSubview:titleLabel];
    } else {    
        self.view.x = 0;
        self.view.width = SCR_WIDTH;
        if (CZGetY([self.view.subviews lastObject]) < tableViewHeight) {
            self.view.height = tableViewHeight;
        } else {
            self.view.height = CZGetY([self.view.subviews lastObject]);
        }
    }
    
}

- (void)setupTopView
{
    // 表
    [self.view addSubview:self.tableView];
    
    self.listCount = self.reportDatasArr.count;
    if (self.listCount > 7) {
        self.listCount = 7;
        self.tableView.height = self.listCount * cellHeight;
        CZMutContentButton *rightBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"right-blue"] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
        [rightBtn setTitleColor:UIColorFromRGB(0x4A90E2) forState:UIControlStateNormal];
        [self.view addSubview:rightBtn];
        [rightBtn sizeToFit];
        rightBtn.centerX = self.view.width / 2.0;
        rightBtn.y = CZGetY(self.tableView) + 20;
        [rightBtn addTarget:self action:@selector(checkAllReport) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.listCount == 7) {
        self.tableView.height = self.listCount * cellHeight;
    } else {
        self.tableView.height = self.listCount * cellHeight;
    }
}

- (void)checkAllReport
{
    CZTrialAllReportHotController *vc = [[CZTrialAllReportHotController alloc] init];
    vc.goodsId = self.goodId;
    [self.navigationController pushViewController:vc animated:YES];
}

// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrialReportMainCell *cell = [CZTrialReportMainCell cellWithTableView:tableView];
    cell.trailReportModel = self.reportDatasArr[indexPath.row];
    return cell;
}

// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        CZTrailReportModel *model = self.reportDatasArr[indexPath.row];
        CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
        vc.detailType = CZJIPINModuleTrail;
        vc.findgoodsId = model.articleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
