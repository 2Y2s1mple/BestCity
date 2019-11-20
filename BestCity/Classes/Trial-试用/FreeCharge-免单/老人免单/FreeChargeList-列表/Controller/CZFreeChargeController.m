//
//  CZFreeChargeController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeController.h"
// 视图
#import "CZFreeChargeCell.h"
#import "CZCZFreeChargeCell2.h"
#import "CZFreeAlertView.h"



// 跳转
#import "CZFreeChargeDetailController.h"
#import "CZUMConfigure.h"

@interface CZFreeChargeController ()
/** 控制分享按钮的点击 */
@property (nonatomic, assign) NSInteger controlClickedNumber;
@end

@implementation CZFreeChargeController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 83 : 49)) style:UITableViewStylePlain];
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

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [CZFreeChargeModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"Id" : @"id"
                 };
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    // 表
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - 获取数据
- (void)setupRefresh
{
    self.tableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreTrailDataSorce)];
}

- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    self.page = 1;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @( self.page);
    param[@"type"] = @(1);

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
    param[@"type"] = @(1);

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

#pragma mark - 代理
// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.freeChargeDatas.count  + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CZFreeChargeCell *cell = [CZFreeChargeCell cellWithTableView:tableView];
        return cell;
    } else {
        CZCZFreeChargeCell2 *cell = [CZCZFreeChargeCell2 cellWithTableView:tableView];
        cell.model = self.freeChargeDatas[indexPath.row - 1];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 288;
    } else {
        return 140;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.row == 0) {
         if ([JPTOKEN length] <= 0) {
             CZLoginController *vc = [CZLoginController shareLoginController];
             UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
             [tabbar presentViewController:vc animated:NO completion:nil];
             return;
         }
         [self getShareImage];
     } else {
         //push到详情
         NSDictionary *model = self.freeChargeDatas[indexPath.row - 1];
         CZFreeChargeDetailController *vc = [[CZFreeChargeDetailController alloc] init];
         vc.Id = model[@"id"];
         vc.isOldUser = YES;
         [self.navigationController  pushViewController:vc animated:YES];
     }
}

- (void)getShareImage
{
    self.controlClickedNumber++;
    if (self.controlClickedNumber > 1) {
        return;
    }

    CURRENTVC(currentVc);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/free/getShareInfo"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD hideAfterDelay:0];
            NSDictionary *param = result[@"data"];
            [[CZFreeAlertView freeAlertViewRightBlock:^(CZFreeAlertView * _Nonnull alertView) {
                [[CZUMConfigure shareConfigure] sharePlatform:UMSocialPlatformType_WechatSession controller:currentVc url:@"https://www.jipincheng.cn" Title:param[@"shareTitle"] subTitle:param[@"shareContent"] thumImage:param[@"shareImg"] shareType:CZUMConfigureTypeMiniProgramFreeOldUserList object:@""];
            } leftBlock:^(CZFreeAlertView * _Nonnull alertView) {
                [[CZUMConfigure shareConfigure] sharePlatform:UMSocialPlatformType_WechatTimeLine controller:currentVc url:@"https://www.jipincheng.cn" Title:param[@"shareTitle"] subTitle:param[@"shareContent"] thumImage:param[@"posterImg"] shareType:CZUMConfigureTypeImage object:@""];
            }] show];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:1.5];
        }
        self.controlClickedNumber = 0;
        //隐藏菊花
    } failure:^(NSError *error) {
        [CZProgressHUD hideAfterDelay:0];
        self.controlClickedNumber = 0;
    }];
}



@end
