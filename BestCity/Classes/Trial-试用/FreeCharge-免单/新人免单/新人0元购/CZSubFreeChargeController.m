//
//  CZSubFreeChargeController.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZSubFreeChargeController.h"
// 群组1
#import "CZFreeChargeCell3.h"
#import "CZFreeChargeCell4.h"
#import "CZFreeChargeCell5.h"

#import "CZSubFreeChargeModel.h"
#import "CZNavigationView.h"

// 群组2
#import "CZFreeChargeCell6.h"
#import "CZFreeChargeCell7.h"

#import "CZAlertView2Controller.h"

@interface CZSubFreeChargeController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataSource;
/** 未展开数据 */
@property (nonatomic, strong) NSMutableArray *upDataSource;
/** 展开数据 */
@property (nonatomic, strong) NSMutableArray *downDataSource;
/** 下面的数据 */
@property (nonatomic, strong) NSMutableArray *group2DataSource;
/** 我的津贴 */
@property (nonatomic, strong) NSNumber *allowance;
/** 官方微信 */
@property (nonatomic, strong) NSString *officialWeChat;

/** 给弹框的数据 */
@property (nonatomic, strong) NSDictionary *alertViewParam;

@end

@implementation CZSubFreeChargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xEA4F17);
    [CZSubFreeChargeModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"Id" : @"id"
                 };
    }];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"新人0元专区" rightBtnTitle:nil rightBtnAction:nil];
    navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView = navigationView;
    [self.view addSubview:navigationView];

    // 表
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];

    // 第一次离开新人0元购
    if (![CZSaveTool leaveOnceNew0yuan]) {
        UIButton *btn = [[UIButton alloc] init];
        btn.size = CGSizeMake(100, 100);
        btn.backgroundColor = [RANDOMCOLOR colorWithAlphaComponent:0.01];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(pushALert2ViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
       CGRect frame = CGRectMake(0, CZGetY(self.navigationView), SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 34 : 0) - CZGetY(self.navigationView));
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.backgroundColor = UIColorFromRGB(0xEA4F17);
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreTrailDataSorce)];
}



- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @( self.page);
    param[@"type"] = @(0);

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"response_1578045033088.json" withExtension:@""];
    NSString *urlStr = [JPSERVER_URL stringByAppendingPathComponent:@"api/allowance/newIndex"];

    //获取数据
    [GXNetTool GetNetWithUrl:urlStr body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.alertViewParam = result[@"data"];
            self.allowance = result[@"data"][@"allowance"];
            self.officialWeChat = result[@"data"][@"officialWeChat"];
            [self upArrowData:result[@"data"][@"newAllowanceGoodsList"]];
            [self downArrowData:result[@"data"][@"newAllowanceGoodsList"]];
            [self group2Data:result[@"data"][@"allowanceGoodsList"]];

            self.dataSource = self.upDataSource;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataSource.count;
    } else {
        return self.group2DataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CZSubFreeChargeModel *model = self.dataSource[indexPath.row];
        if ([model.typeNumber  isEqual: @(1)]) {
            CZFreeChargeCell3 *cell = [CZFreeChargeCell3 cellWithTableView:tableView];
            cell.model = model;
            return cell;
        } else if ([model.typeNumber  isEqual: @(100)] || [model.typeNumber  isEqual: @(101)]) {
            CZFreeChargeCell5 *cell = [CZFreeChargeCell5 cellWithTableView:tableView];
            cell.model = model;
            return cell;
        } else {
            CZFreeChargeCell4 *cell = [CZFreeChargeCell4 cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }
    } else {
        CZSubFreeChargeModel *model = self.group2DataSource[indexPath.row];
        if ([model.typeNumber  isEqual: @(1)]) {
            CZFreeChargeCell6 *cell = [CZFreeChargeCell6 cellWithTableView:tableView];
            cell.model = model;
            return cell;
        } else {
            CZFreeChargeCell7 *cell = [CZFreeChargeCell7 cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.section == 0) {
         CZSubFreeChargeModel *model = self.dataSource[indexPath.row];
         if ([model.typeNumber isEqual: @(100)]) {
             self.dataSource = self.downDataSource;
             [self.tableView reloadData];
         } else if ([model.typeNumber isEqual: @(101)]) {
             self.dataSource = self.upDataSource;
             [self.tableView reloadData];
         }
     } else {
         
     }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CZSubFreeChargeModel *model = self.dataSource[indexPath.row];
        return model.cellHeight;
    } else {
        CZSubFreeChargeModel *model = self.group2DataSource[indexPath.row];
        return model.cellHeight;

    }

}


#pragma mark -- UI创建

#pragma mark -- 数据处理
- (void)upArrowData:(NSArray *)list
{
    self.upDataSource = [CZSubFreeChargeModel objectArrayWithKeyValuesArray:list];
    [self.upDataSource removeObjectsInRange:NSMakeRange(2, self.upDataSource.count - 2)];
    CZSubFreeChargeModel *model1 = [[CZSubFreeChargeModel alloc] init];
    model1.officialWeChat = self.officialWeChat;
    model1.typeNumber = @(1);
    [self.upDataSource insertObject:model1 atIndex:0];
    CZSubFreeChargeModel *model2 = [[CZSubFreeChargeModel alloc] init];
    model2.typeNumber = @(100);
    [self.upDataSource addObject:model2];
}

- (void)downArrowData:(NSArray *)list
{
    self.downDataSource = [CZSubFreeChargeModel objectArrayWithKeyValuesArray:list];
    CZSubFreeChargeModel *model1 = [[CZSubFreeChargeModel alloc] init];
    model1.officialWeChat = self.officialWeChat;
    model1.typeNumber = @(1);
    [self.downDataSource insertObject:model1 atIndex:0];
    CZSubFreeChargeModel *model2 = [[CZSubFreeChargeModel alloc] init];
    model2.typeNumber = @(101);
    [self.downDataSource addObject:model2];
}


- (void)group2Data:(NSArray *)list
{
    self.group2DataSource = [CZSubFreeChargeModel objectArrayWithKeyValuesArray:list];
    CZSubFreeChargeModel *model1 = [[CZSubFreeChargeModel alloc] init];
    model1.allowance = self.allowance;
    model1.typeNumber = @(1);
    [self.group2DataSource insertObject:model1 atIndex:0];
}

#pragma mark -- 事件
- (void)pushALert2ViewController:(UIButton *)sender
{
    [sender removeFromSuperview];
    CZAlertView2Controller *vc = [[CZAlertView2Controller alloc] init];
    vc.param = self.alertViewParam;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:^{
    }];
}

@end
