//
//  CZCoinCenterController.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCoinCenterController.h"
#import "GXNetTool.h"
#import "CZMyPointDetailController.h"
#import "TSLWebViewController.h"
#import "CZTaskMainView.h"

@interface CZCoinCenterController () <CZTaskMainViewDelegate>
/** 顶部的隐藏的导航栏 */
@property (nonatomic, strong) UIView *navView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *todayPointLabel;
@property (nonatomic, weak) IBOutlet UILabel *todayPointNumber;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *usablePointLabel;
@property (nonatomic, weak) IBOutlet UILabel *usablePointNumber;

/** 连续签到天数 */
@property (nonatomic, assign) NSInteger daysCountNumber;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *remarkView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *backView;

/** 数据 */
@property (nonatomic, strong) NSDictionary *dataSource;

/** 每日任务视图 */
@property (nonatomic, strong) CZTaskMainView *taskView;
/** 每日任务数据 */
@property (nonatomic, strong) NSArray *taskData;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;


@end

@implementation CZCoinCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataSource];
    [self createNav];
    self.todayPointLabel.font= [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.usablePointLabel.font = self.todayPointLabel.font;
    self.backView.layer.cornerRadius = 10;
    
    
    // 创建每日任务视图
    [self getTaskViewData];
}

- (void)getTaskViewData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/dailytask/list"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.taskData = result[@"data"];
            // 创建每日任务视图
            self.taskView = [[CZTaskMainView alloc] initWithFrame:CGRectMake(14, CZGetY(self.backView) + 20, SCR_WIDTH - 28, 50)];
            self.taskView.dataSource = self.taskData;
            self.taskView.delegate = self;
            self.taskView.backgroundColor = CZGlobalWhiteBg;
            [self.scrollView addSubview:self.taskView];
            self.scrollView.contentSize = CGSizeMake(SCR_WIDTH, CZGetY(self.taskView) + 100);
        } 
    } failure:^(NSError *error) {}];
}

#pragma mark - <CZTaskMainViewDelegate>
- (void)reloadContentView
{
    self.scrollView.contentSize = CGSizeMake(SCR_WIDTH, CZGetY(self.taskView) + 100);
}

- (void)createNav
{
    // 设置最上面的导航栏, 实现滑动改变透明效果
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, SCR_WIDTH, 64);
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    self.navView = navView;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBtn setImage:[UIImage imageNamed:@"back-white"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(20, 20, 49, navView.height - 20);
    leftBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:leftBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
    titleLabel.text = @"极币中心";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.center = CGPointMake(SCR_WIDTH / 2, leftBtn.center.y);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [self.navView addSubview:titleLabel];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCR_WIDTH - 100, titleLabel.y, 80, 20);
    [rightBtn setTitle:@"规则说明" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.navView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(didClickedRightBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 20 ) {
        self.navView.backgroundColor = CZRGBColor(255, 93, 68);;
    } else {
        self.navView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - 获取数据
- (void)getDataSource
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/signinDetail"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.dataSource = result[@"data"];
            [self update];
        } 
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {}];
}

- (void)update
{
    self.todayPointNumber.text = [NSString stringWithFormat:@"%@", self.dataSource[@"pointAccount"][@"todayPoint"]];
    self.usablePointNumber.text = [NSString stringWithFormat:@"%@", self.dataSource[@"pointAccount"][@"usablePoint"]];
    self.daysCountNumber = [self.dataSource[@"daysCount"] integerValue];
    
    for (int i = 0; i < 7; i++) {
        UIImageView *coinImage =  self.remarkView.subviews[i];
        
        UILabel *subLabel = [coinImage viewWithTag:105];
        if (subLabel == nil) {
            subLabel = [[UILabel alloc] init];
            subLabel.tag = 105;
            subLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
            subLabel.text = [NSString stringWithFormat:@"+%@", self.dataSource[@"pointArr"][i]];
            [subLabel sizeToFit];
            subLabel.textColor = [UIColor whiteColor];
            subLabel.centerX = 15;
            subLabel.centerY = 15;
            [coinImage addSubview:subLabel];
        } else {
            subLabel.text = [NSString stringWithFormat:@"+%@", self.dataSource[@"pointArr"][i]];
        }
    }
    
    for (int i = 0; i < 7; i++) {
        UIImageView *coinImage =  self.remarkView.subviews[i];
        if (i < self.daysCountNumber) {        
            coinImage.highlighted = YES;
            [[coinImage viewWithTag:105] removeFromSuperview];
        } else {
            coinImage.highlighted = NO;
        }
    }
}

/** 跳转规则说明 */
- (void)didClickedRightBtn
{
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:POINTSRULE_URL]];
    webVc.titleName = @"规则说明";
    [self presentViewController:webVc animated:YES completion:nil];
}

#pragma mark - 跳转到积分详情
- (IBAction)pushPointDetail
{
    CZMyPointDetailController *vc = [[CZMyPointDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 签到
- (IBAction)remarkInsert
{
    NSString *text = @"我要赚极币--签到";
    NSDictionary *context = @{@"sign" : text};
    [MobClick event:@"ID5" attributes:context];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/signin"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"签到成功"];
            [self getDataSource];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

@end
