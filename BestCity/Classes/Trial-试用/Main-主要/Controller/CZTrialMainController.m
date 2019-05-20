//
//  CZTrialMainController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialMainController.h"
#import "CZMutContentButton.h"
#import "CZTrialController.h"
#import "CZTrialReportController.h"
//视图
#import "CZTrialMainCell.h"
#import "CZTrialReportMainCell.h"
// 详情
#import "CZTrialDetailController.h"
#import "CZDChoiceDetailController.h" // 报告详情跟测评一个

// 工具
#import "GXNetTool.h"
//模型
#import "CZTrailModel.h"
#import "CZTrailReportModel.h"

@interface CZTrialMainController () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 试用数据 */
@property (nonatomic, strong) NSMutableArray *trialDatasArr;
/** 报告数据 */
@property (nonatomic, strong) NSMutableArray *reportDatasArr;
@end

@implementation CZTrialMainController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 44 : 20) - (IsiPhoneX ? 83 : 49)) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)trialDatasArr
{
    if (_trialDatasArr == nil) {
        _trialDatasArr = [NSMutableArray array];
    }
    return _trialDatasArr;
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/trial/index"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.trialDatasArr = [CZTrailModel objectArrayWithKeyValuesArray:result[@"data"][@"trialList"]];
            self.reportDatasArr = [CZTrailReportModel objectArrayWithKeyValuesArray:result[@"data"][@"reportList"]];
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

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [CZTrailModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"trialId" : @"id"
                 }; 
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    // 表
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];
}

#pragma mark - 视图初始化
- (UIView *)setupTopNavView:(NSString *)title
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 47)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    navLabel.text = title;
    [navigationView addSubview:navLabel];
    navLabel.x = 14;
    navLabel.height = 23;
    navLabel.y = navigationView.height - 23 - 12;
    [navLabel sizeToFit];
    
    CZMutContentButton *rightBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
    
    if ([title isEqualToString:@"免费试用"]) {
        [rightBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(moreTrialDatas:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [rightBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(moreTrialReport:) forControlEvents:UIControlEventTouchUpInside];
    }
    [rightBtn setImage:[UIImage imageNamed:@"right-blue"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    [rightBtn setTitleColor:UIColorFromRGB(0x4A90E2) forState:UIControlStateNormal];
    [navigationView addSubview:rightBtn];
    [rightBtn sizeToFit];
    rightBtn.x = navigationView.width - 85;
    rightBtn.centerY = navLabel.centerY;
    
    return navigationView;
}

#pragma mark - 事件
- (void)moreTrialDatas:(UIButton *)sender
{
    CZTrialController *vc = [[CZTrialController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreTrialReport:(UIButton *)sender
{
    NSString *text = @"试用--试用报告--查看更多";
    NSDictionary *context = @{@"oneTab" : text};
    [MobClick event:@"ID4" attributes:context];
    CZTrialReportController *hotVc = [[CZTrialReportController alloc] init];
    hotVc.menuViewStyle = WMMenuViewStyleLine;
            hotVc.progressWidth = 60;
//    hotVc.itemMargin = 50;
//    hotVc.menuItemWidth = 100;
    hotVc.progressHeight = 3;
    hotVc.automaticallyCalculatesItemWidths = YES;
    hotVc.titleFontName = @"PingFangSC-Medium";
    hotVc.titleColorNormal = CZGlobalGray;
    hotVc.titleColorSelected = [UIColor blackColor];
    hotVc.titleSizeNormal = 14.0f;
    hotVc.titleSizeSelected = 14;
    hotVc.progressColor = CZREDCOLOR;
    [self.navigationController pushViewController:hotVc animated:YES];
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.trialDatasArr.count;
        case 1:
            return self.reportDatasArr.count;
        default:
            break;
    }
    return section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            CZTrialMainCell *cell = [CZTrialMainCell cellWithTableView:tableView];
            cell.trailModel = self.trialDatasArr[indexPath.row];
            return cell;
        }
        case 1:
        {
            CZTrialReportMainCell *cell = [CZTrialReportMainCell cellWithTableView:tableView];
            cell.trailReportModel = self.reportDatasArr[indexPath.row];
            return cell;
        }
        default:
            return nil;
            break;
    }
}



// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 325;
        case 1 :
            return 124;
        default:
            return 0;;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self setupTopNavView:@"免费试用"];
        case 1 :
            return [self setupTopNavView:@"试用报告"];
        default:
            return [self setupTopNavView:@""];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            //push到详情
            if ([JPTOKEN length] <= 0)
            {
                CZLoginController *vc = [CZLoginController shareLoginController];
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                CZTrialDetailController *vc = [[CZTrialDetailController alloc] init];
                CZTrailModel *model = self.trialDatasArr[indexPath.row];
                vc.trialId = model.trialId;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 1 :
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
            break;
        }
        default:
            break;
    }
}


@end
