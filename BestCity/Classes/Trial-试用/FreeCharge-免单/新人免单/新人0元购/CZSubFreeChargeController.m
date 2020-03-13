//
//  CZSubFreeChargeController.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZSubFreeChargeController.h"

// 群组1
#import "CZFreeChargeHeaderView.h"
#import "CZFreeChargeCell4.h"
#import "CZFreeChargeFooterView.h"


#import "CZSubFreeChargeModel.h"
#import "CZNavigationView.h"

// 群组2
#import "CZFreeChargeCell6.h"
#import "CZFreeChargeCell7.h"
#import "CZAlertView2Controller.h"

#import "CZTaobaoDetailNewController.h"

@interface CZSubFreeChargeController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 页数 */
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataSource;
/** 数据个数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 下面的数据 */
@property (nonatomic, strong) NSMutableArray *group2DataSource;
/** 我的津贴 */
@property (nonatomic, strong) NSNumber *allowance;
/** 官方微信 */
@property (nonatomic, strong) NSString *officialWeChat;

/** 给弹框的数据 */
@property (nonatomic, strong) NSDictionary *alertViewParam;

/** */
@property (nonatomic, strong) CZFreeChargeFooterView *footerView;

@end

@implementation CZSubFreeChargeController

- (CZFreeChargeFooterView *)footerView
{
    if (_footerView == nil) {
        _footerView = [CZFreeChargeFooterView freeChargeFooterView];
        [_footerView setBlock:^{
            if (_footerView.isUpArrow == NO) {
                self.dataCount = self.dataSource.count;
//                [self.tableView reloadData];
                _footerView.isUpArrow = YES;

                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:(UITableViewScrollPositionNone) animated:NO];
            } else {
                self.dataCount = 4;
//                [self.tableView reloadData];
                _footerView.isUpArrow = NO;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        }];
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xEA4F17);
    [CZSubFreeChargeModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"Id" : @"id"
                 };
    }];
    //导航条
    UIView *tmpView = [[UIView alloc] init];
    tmpView.backgroundColor = [UIColor whiteColor];
    tmpView.height = (IsiPhoneX ? 26 : 0);
    tmpView.width = SCR_WIDTH;
    [self.view addSubview:tmpView];

    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"新人0元专区" rightBtnTitle:nil rightBtnAction:nil];
    navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView = navigationView;
    [self.view addSubview:navigationView];

    // 表
    [self.view addSubview:self.tableView];
    //创建刷新控件
    [self setupRefresh];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
       CGRect frame = CGRectMake(0, CZGetY(self.navigationView), SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 34 : 0) - CZGetY(self.navigationView));
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
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

#pragma mark - 数据
- (void)reloadNewTrailDataSorce
{
    self.footerView.isUpArrow = NO;

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

            // 组1
            self.dataSource = [CZSubFreeChargeModel objectArrayWithKeyValuesArray:result[@"data"][@"newAllowanceGoodsList"]];
            self.dataCount = 4;

            // 组2
            [self group2Data:result[@"data"][@"allowanceGoodsList"]];

            [self.tableView reloadData];
            // 结束刷新
        }
        [self.tableView.mj_header endRefreshing];
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];

        // 添加弹窗

#pragma mark - 测试代码
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addAlertEvent];
        });
    } failure:^(NSError *error) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.dataSource.count > 4) {
            return self.dataCount;
        } else {
            return self.dataSource.count;
        }
    } else {
        return self.group2DataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CZSubFreeChargeModel *model = self.dataSource[indexPath.row];
        CZFreeChargeCell4 *cell = [CZFreeChargeCell4 cellWithTabelView:tableView indexPath:indexPath];
        cell.model = model;
        return cell;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CZFreeChargeHeaderView *v = [CZFreeChargeHeaderView freeChargeHeaderView];
        v.officialWeChat = self.officialWeChat;
        return v;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.dataSource.count > 2) {
            return self.footerView;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 360;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.dataSource.count > 4) {
            return 55;
        } else {
            return 0.01;
        }
    } else {
        return 0.01;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CZSubFreeChargeModel *model = self.dataSource[indexPath.row];
        CZTaobaoDetailNewController *vc = [[CZTaobaoDetailNewController alloc] init];
        vc.allowanceGoodsId = model.Id;
        vc.otherGoodsId = model.otherGoodsId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
//        CZSubFreeChargeModel *model = self.group2DataSource[indexPath.row];
//        CZTaobaoDetailNewController *vc = [[CZTaobaoDetailNewController alloc] init];
//        vc.allowanceGoodsId = model.Id;
//        vc.otherGoodsId = model.otherGoodsId;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    [self touchesBegan:nil withEvent:nil];
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

// 添加弹窗逻辑
- (void)addAlertEvent
{
    self.tableView.scrollEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 第一次离开新人0元购
//        [CZSaveTool setObject:@"www" forKey:@"leaveOnceNew0yuan"];
           if ([CZSaveTool leaveOnceNew0yuan]) {
               UIButton *btn = [[UIButton alloc] init];
               btn.size = CGSizeMake(100, 100);
               btn.backgroundColor = [RANDOMCOLOR colorWithAlphaComponent:0.01];
               [self.view addSubview:btn];
               [btn addTarget:self action:@selector(pushALert2ViewController:) forControlEvents:UIControlEventTouchUpInside];

               // 上部d挡板
               UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
               NSLog(@"%@", cell);

               UIView *topView = [[UIView alloc] init];
               topView.width = SCR_WIDTH;
               topView.height = cell.y + self.tableView.y;
               topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
               [self.view addSubview:topView];
               topView.tag = 100;

               UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-13"]];
               imageView.centerX = SCR_WIDTH / 2;
               imageView.y = topView.height - 130;
               [topView addSubview:imageView];

               // 下部挡板
               UITableViewCell *bottomCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
               UIView *bottomView = [[UIView alloc] init];
               bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
               bottomView.y = bottomCell.y + self.tableView.y;
               bottomView.width = SCR_WIDTH;
               bottomView.height = SCR_HEIGHT - bottomCell.y - self.tableView.y;
               [self.view addSubview:bottomView];
               bottomView.tag = 200;

               UIButton *btn1 = [[UIButton alloc] init];
               [btn1 setBackgroundImage:[UIImage imageNamed:@"alert-12"] forState:UIControlStateNormal];
               [btn1 sizeToFit];
               btn1.centerX = SCR_WIDTH / 2;
               btn1.y = 20;
               btn1.tag = 100;
               [bottomView addSubview:btn1];
               [btn1 addTarget:self action:@selector(removeAlertView:) forControlEvents:UIControlEventTouchUpInside];
           } else {
               // 0.25秒激活, 因为一开始不让tableView动
               self.tableView.scrollEnabled = YES;
           }
    });
}

// 删除提示框
- (void)removeAlertView:(UIButton *)sender
{
    [sender removeFromSuperview];
    UIView *view1 = [self.view viewWithTag:100];
    UIView *view2 = [self.view viewWithTag:200];
    [view1 removeFromSuperview];
    [view2 removeFromSuperview];
    self.tableView.scrollEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *view2 = [self.view viewWithTag:200];
    UIButton *btn = [view2 viewWithTag:100];
    [self removeAlertView:btn];
}


@end
