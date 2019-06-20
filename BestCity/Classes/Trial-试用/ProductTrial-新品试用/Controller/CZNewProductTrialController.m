//
//  CZNewProductTrialController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZNewProductTrialController.h"
#import "CZMutContentButton.h"
#import "CZTrialController.h"
#import "CZTrialReportController.h"
//视图
#import "CZTrialMainCell.h"
#import "CZTrialReportMainCell.h"
#import "CZScollerImageTool.h"
// 详情
#import "CZTrialDetailController.h"
#import "CZDChoiceDetailController.h" // 报告详情跟测评一个

// 工具
#import "GXNetTool.h"
//模型
#import "CZTrailModel.h"
#import "CZTrailReportModel.h"

@interface CZNewProductTrialController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 试用数据 */
@property (nonatomic, strong) NSMutableArray *trialDatasArr;
/** 报告数据 */
@property (nonatomic, strong) NSMutableArray *reportDatasArr;
@end

@implementation CZNewProductTrialController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - ((IsiPhoneX ? 44 : 20) + 50 + (IsiPhoneX ? 83 : 49))) style:UITableViewStyleGrouped];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
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

// 获取轮播图数据
- (void)getBannerImage
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"location"] = @"4";
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/adList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            // 结束刷新
            NSMutableArray *images = [NSMutableArray array];
            for (NSDictionary *dic in result[@"data"]) {
                [images addObject:dic[@"img"]];
            }
            self.tableView.tableHeaderView = [self setupTableViewHeader:images];
        }
    } failure:^(NSError *error) {}];
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
    // 获取轮播图
    [self getBannerImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - 视图初始化
- (UIView *)setupHeaderView:(NSString *)title
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 60)];
    backView.backgroundColor =UIColorFromRGB(0xF5F5F5);

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    titleLabel.text = title;
    [backView addSubview:titleLabel];
    titleLabel.x = 14;
    [titleLabel sizeToFit];
    titleLabel.centerY = backView.height / 2.0;
    return backView;
}

- (UIView *)setupFooterView:(NSString *)title
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 47)];
    backView.backgroundColor = [UIColor whiteColor];
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
    [backView addSubview:rightBtn];
    [rightBtn sizeToFit];
    rightBtn.centerX = backView.width / 2.0;
    rightBtn.y = 20;

    return backView;
}

// tableView的头视图
- (UIView *)setupTableViewHeader:(NSArray *)images
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 190)];

    CZScollerImageTool *imageView = [[CZScollerImageTool alloc] initWithFrame:CGRectMake(14, 10, SCR_WIDTH - 28, 170)];
    [backView addSubview:imageView];
    imageView.imgList = images;
    [backView addSubview:imageView];
    return backView;
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
            return 300;
        case 1 :
            return 114;
        default:
            return  0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        if (self.reportDatasArr.count != 0) {
            return 60;
        } else {
            return 0.01;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.trialDatasArr.count != 0) {
            return 57;
        } else {
            return 0.01;
        }
    } else {
        if (self.reportDatasArr.count != 0) {
            return 57;
        } else {
            return 0.01;
        }
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        if (self.reportDatasArr.count != 0) {
            return [self setupHeaderView:@"试用报告"];;
        } else {
            return nil;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return [self setupFooterView:@"免费试用"];
    } else {
        if (self.reportDatasArr.count != 0) {
            return [self setupFooterView:@"试用报告"];
        } else {
            return nil;
        }
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
