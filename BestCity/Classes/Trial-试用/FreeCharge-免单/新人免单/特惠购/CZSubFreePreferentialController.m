//
//  CZSubFreePreferentialController.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/6.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSubFreePreferentialController.h"

#import "CZSubFreeChargeModel.h"
#import "CZNavigationView.h"

#import "CZSubFreePreferentialCell1.h"
#import "CZFreeChargeCell7.h"

// 工具
#import "GXNetTool.h"

#import "CZAlertView3Controller.h"



@interface CZSubFreePreferentialController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CZSubFreePreferentialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xEA4F17);
    [CZSubFreeChargeModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"Id" : @"id"
                 };
    }];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"百万补贴特惠购" rightBtnTitle:nil rightBtnAction:nil];
    navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView = navigationView;
    [self.view addSubview:navigationView];

    // 表
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];


    // 完成了首次下单
    if (!self.isfirstOrder) {
        //获取数据
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"type"] = @(3);
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"getPopInfo.json" withExtension:nil];
        NSString *urlStr = [JPSERVER_URL stringByAppendingPathComponent:@"api/v2/getPopInfo"];

        [GXNetTool GetNetWithUrl:url.absoluteString body:param header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"msg"] isEqualToString:@"success"]) {
                NSDictionary *param = result[@"data"];
                NSLog(@"%@----%@", param, [param class]);
                if ([param isKindOfClass:[NSNull class]])
                {
                    return;
                }
                if ([result[@"data"][@"type"] isEqualToNumber:@3]) {
                    CZAlertView3Controller *vc = [[CZAlertView3Controller alloc] init];
                    vc.param = result[@"data"];
                    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }
        } failure:^(NSError *error) {

        }];

    }
}

- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @( self.page);
    param[@"type"] = @(0);

    NSString *urlStr = [JPSERVER_URL stringByAppendingPathComponent:@"api/allowance/index"];

    //获取数据
    [GXNetTool GetNetWithUrl:urlStr body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = [CZSubFreeChargeModel objectArrayWithKeyValuesArray:result[@"data"][@"allowanceGoodsList"]];
            CZSubFreeChargeModel *model = [[CZSubFreeChargeModel alloc] init];
            model.allowance = result[@"data"][@"allowance"];
            model.totalUsedAllowance = result[@"data"][@"totalUsedAllowance"];
            [self.dataSource insertObject:model atIndex:0];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZSubFreeChargeModel *model = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        CZSubFreePreferentialCell1 *cell = [CZSubFreePreferentialCell1 cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else {
        CZFreeChargeCell7 *cell = [CZFreeChargeCell7 cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZSubFreeChargeModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}


@end
