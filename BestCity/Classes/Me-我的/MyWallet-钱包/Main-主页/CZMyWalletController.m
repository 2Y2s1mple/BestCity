//
//  CZMyWalletController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletController.h"
#import "CZMyWalletDepositController.h"
#import "GXNetTool.h"

#import "CZMyWalletCell.h" // 视图
#import "CZMyWalletWithdrawCell.h"

#import "CZMyWalletModel.h" // 模型
#import "CZWithdrawModel.h"

// 跳转
#import "CZMyWalletDetailController.h"
#import "TSLWebViewController.h"


@interface CZMyWalletController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollerView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *lineView;

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *leftLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;

// xib上控件
/** 综合信息 */
@property (nonatomic, strong) NSDictionary *synthesizeDic;
/** 总数 */
@property (nonatomic, weak) IBOutlet UILabel *totalPrice;
/** 上个月预估 */
@property (nonatomic, weak) IBOutlet UILabel *nextLabel;
/** 本月 */
@property (nonatomic, weak) IBOutlet UILabel *currentLabel;
/** 已提现 */
@property (nonatomic, weak) IBOutlet UILabel *withdrawLabel;

/** 左面数据 */
@property (nonatomic, strong) NSArray *detailList;
/** 右边数据 */
@property (nonatomic, strong) NSMutableArray *rightList;

/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 没有数据图片 */
@property (nonatomic, strong) CZNoDataView *noDataView;
@property (nonatomic, strong) CZNoDataView *noDataView1;
@end

@implementation CZMyWalletController
#pragma mark - 懒加载
- (CZNoDataView *)noDataView
{
    if (_noDataView == nil) {
        self.noDataView = [CZNoDataView noDataView];
        self.noDataView.backgroundColor = [UIColor clearColor];
        self.noDataView.centerX = SCR_WIDTH / 2.0;
        self.noDataView.y = self.scrollerView.height / 2.0;
    }
    return _noDataView;
}
#pragma mark - 获取数据
// 获取收入明细
- (void)getIncomeDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getCommssionDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                self.noDataView1 = [CZNoDataView noDataView];
                self.noDataView1.center = self.leftTableView.center;
                self.noDataView1.backgroundColor = [UIColor clearColor];
                [self.scrollerView addSubview:self.noDataView1];
            }

            self.detailList = [CZMyWalletModel objectArrayWithKeyValuesArray:result[@"data"]];
            

            [self.leftTableView reloadData];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

// 获取佣金总数
- (void)getcommissionDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/myCommssionSummary"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
            self.synthesizeDic = result[@"data"];
            // 给控件赋值
            [self assignmentWithModule];
        }
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollerView
{
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CZGetY(self.leftLabel) + 24, SCR_WIDTH, SCR_HEIGHT - CZGetY(self.leftLabel) - 24)];
        _scrollerView.backgroundColor = CZGlobalLightGray;
    }
    return _scrollerView;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取收入明细数据
    [self getIncomeDataSource];
    // 获取佣金总数
    [self getcommissionDataSource];

    if (@available(iOS 11.0, *)) {
        self.scrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.view addSubview:self.scrollerView];
    self.scrollerView.contentSize = CGSizeMake(SCR_WIDTH * 2, 0);
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.delegate = self;

    // 初始化控件
    [self setupUI];

}

#pragma mark - 控件赋值
- (void)assignmentWithModule
{
    self.totalPrice.text = [NSString stringWithFormat:@"¥%.2lf", [self.synthesizeDic[@"balanceFee"] floatValue]];
    self.totalPrice.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 25.5];

    // 上月
    self.nextLabel.text = [NSString stringWithFormat:@"¥%.2lf", [self.synthesizeDic[@"preMonthFee"] floatValue]];
    self.nextLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];

    // 本月
    self.currentLabel.text = [NSString stringWithFormat:@"¥%.2lf", [self.synthesizeDic[@"currentMonthFee"] floatValue]];
    self.currentLabel.font = self.nextLabel.font;

    // 已提现
    self.withdrawLabel.text = [NSString stringWithFormat:@"¥%.2lf", [self.synthesizeDic[@"withdraw"] floatValue]];
    self.withdrawLabel.font = self.nextLabel.font;
}

#pragma mark - UI初始化
- (void)setupUI
{
    self.leftLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    self.rightLabel.font = self.leftLabel.font;


    // 收入明细
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(14, 0, SCR_WIDTH - 28, self.scrollerView.height) style:UITableViewStylePlain];

    [self.scrollerView addSubview:leftTableView];
    self.leftTableView = leftTableView;
    leftTableView.backgroundColor = CZGlobalLightGray;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 提现明细
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCR_WIDTH + 14, 0, SCR_WIDTH - 28, self.scrollerView.height) style:UITableViewStylePlain];
    [self.scrollerView addSubview:rightTableView];
    self.rightTableView = rightTableView;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTableView.backgroundColor = CZGlobalLightGray;
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.rightTableView.mj_header = [CZCustomGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewTrailDataSorce)];
    [self.rightTableView.mj_header beginRefreshing];
    self.rightTableView.mj_footer = [CZCustomGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTrailDataSorce)];
}

// 获取提现明细
- (void)reloadNewTrailDataSorce
{
    // 结束尾部刷新
    [self.rightTableView.mj_footer endRefreshing];
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"status"] = @(0);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getWithdrawDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            if ([result[@"data"] count] > 0) {
                // 删除noData图片
                [self.noDataView removeFromSuperview];
            } else {
                // 加载NnoData图片
                self.noDataView.center = self.rightTableView.center;
                [self.scrollerView addSubview:self.noDataView];
            }


            self.rightList = [CZWithdrawModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.rightTableView reloadData];
        }
        // 结束刷新
        [self.rightTableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce
{
    // 先结束头部刷新
    [self.rightTableView.mj_header endRefreshing];
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"status"] = @(0);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getWithdrawDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *arr = [CZWithdrawModel objectArrayWithKeyValuesArray:result[@"data"]];
            [self.rightList addObjectsFromArray:arr];
            [self.rightTableView reloadData];
        }
        // 结束刷新
        [self.rightTableView.mj_footer endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}




#pragma mark - 点击事件

- (IBAction)gotoHtml:(UIButton *)sender {
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/commission-rule.html"]];
    webVc.titleName = @"规则说明";
    [self presentViewController:webVc animated:YES completion:nil];
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftActoin:(UITapGestureRecognizer *)sender {
    NSLog(@"----------%@", sender.view);
    CGFloat lineX = sender.view.frame.origin.x;
    self.leftLabel.textColor = [UIColor blackColor];
    self.lineView.x = lineX;

    self.rightLabel.textColor = CZGlobalGray;
    [self.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)rightAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"----------%@", sender.view);
    CGFloat lineX = sender.view.frame.origin.x;
    self.rightLabel.textColor = [UIColor blackColor];
    self.lineView.x = lineX;

    self.leftLabel.textColor = CZGlobalGray;
    [self.scrollerView setContentOffset:CGPointMake(SCR_WIDTH, 0) animated:YES];
}

/* 条转提现 */
- (IBAction)pushWithdrawDeposit
{
    CZMyWalletDepositController *vc = [[CZMyWalletDepositController alloc] init];
    vc.amount = self.synthesizeDic[@"balanceFee"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.detailList.count;
    } else {
        return self.rightList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        CZMyWalletCell *cell = [CZMyWalletCell cellWithTabelView:tableView];
        cell.model = self.detailList[indexPath.row];
        return cell;
    } else {
        CZMyWalletWithdrawCell *cell = [CZMyWalletWithdrawCell cellWithTabelView:tableView];
        cell.model = self.rightList[indexPath.row];
        if (indexPath.row == 0) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 28, cell.model.cellHeight) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer  alloc]  init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
        if (indexPath.row == self.rightList.count - 1) {
            UIBezierPath *bezierPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 28, cell.model.cellHeight) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *mask = [[CAShapeLayer alloc] init];
            mask.frame = cell.bounds;
            mask.path = bezierPath.CGPath;
            cell.layer.mask = mask;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        CZMyWalletModel *model = self.detailList[indexPath.row];
        return model.cellHeight;
    } else {
        CZWithdrawModel *model = self.rightList[indexPath.row];
        return model.cellHeight;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        CZMyWalletDetailController *vc = [[CZMyWalletDetailController alloc] init];
        vc.detailList = self.detailList;
        vc.index = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollerView) {
        NSLog(@"------");
        if (scrollView.contentOffset.x == SCR_WIDTH) {
            self.leftLabel.textColor = CZGlobalGray;
            self.rightLabel.textColor = [UIColor blackColor];
            self.lineView.x = self.rightLabel.x;
        } else if (scrollView.contentOffset.x == 0) {
            self.rightLabel.textColor = CZGlobalGray;
            self.leftLabel.textColor = [UIColor blackColor];
            self.lineView.x = self.leftLabel.x;
        }
    }
}


@end
