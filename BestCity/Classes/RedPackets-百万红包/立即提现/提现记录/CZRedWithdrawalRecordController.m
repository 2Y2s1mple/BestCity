//
//  CZRedWithdrawalRecordController.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedWithdrawalRecordController.h"
#import "GXNetTool.h"
#import "CZNavigationView.h"
#import "CZRedWithdrawalRecordCell.h"

@interface CZRedWithdrawalRecordController () <UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CZRedWithdrawalRecordController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CZGetY(self.navigationView) + 40, SCR_WIDTH, SCR_HEIGHT - CZGetY(self.navigationView) - 40) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"提现记录" rightBtnTitle:@"帮助" rightBtnAction:^{
        CURRENTVC(currentVc);
        TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/tixian_help.html"]];
        webVc.titleName = @"提现帮助";
        [currentVc presentViewController:webVc animated:YES completion:nil];
    } ];
    navigationView.backgroundColor = CZGlobalWhiteBg;
    [self.view addSubview:navigationView];
    self.navigationView = navigationView;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    imageView.image = [UIImage imageNamed:@"redPackets-15"];
    imageView.y = CZGetY(self.navigationView);
    imageView.width = SCR_WIDTH;
    imageView.height = 40;
    [self.view addSubview:imageView];

    // 创建表
    [self.view addSubview:self.tableView];

    [self setupRefresh];
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"status"] = @(0);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/withdrawLog"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = result[@"data"];
            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.tableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"status"] = @(0);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/withdrawLog"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {


            [self.tableView reloadData];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZRedWithdrawalRecordCell *cell = [CZRedWithdrawalRecordCell cellwithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}



@end
