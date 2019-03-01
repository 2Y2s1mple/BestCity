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

@interface CZCoinCenterController ()
/** 顶部的隐藏的导航栏 */
@property (nonatomic, strong) UIView *navView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *totalPointLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalPointNumber;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *todayPointLabel;
@property (nonatomic, weak) IBOutlet UILabel *todayPointNumber;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *usablePointLabel;
@property (nonatomic, weak) IBOutlet UILabel *usablePointNumber;

/** 连续签到 */
@property (nonatomic, weak) IBOutlet UILabel *daysCountNumber;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *remarkView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *backView;

/** 数据 */
@property (nonatomic, strong) NSDictionary *dataSource;

/** 飘飞的label */
@property (nonatomic, weak) IBOutlet UILabel *piaopiaoLabel;
@end

@implementation CZCoinCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.piaopiaoLabel.hidden = YES;
    [self getDataSource];
    [self createNav];
    self.totalPointLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.todayPointLabel.font= [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.usablePointLabel.font = self.todayPointLabel.font;
    self.backView.layer.cornerRadius = 10;
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
    titleLabel.text = @"极币中心 ";
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
    self.totalPointNumber.text = [NSString stringWithFormat:@"%@", self.dataSource[@"pointAccount"][@"totalPoint"]];
    self.todayPointNumber.text = [NSString stringWithFormat:@"%@", self.dataSource[@"pointAccount"][@"todayPoint"]];
    self.usablePointNumber.text = [NSString stringWithFormat:@"%@", self.dataSource[@"pointAccount"][@"usablePoint"]];
    self.daysCountNumber.text = [NSString stringWithFormat:@"%@",self.dataSource[@"daysCount"]];
    
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
        if (i < [self.daysCountNumber.text integerValue]) {        
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/signin"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"签到成功"];
            self.piaopiaoLabel.text = [NSString stringWithFormat:@"+%@极币", result[@"addPoint"]];
            self.piaopiaoLabel.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.piaopiaoLabel.transform = CGAffineTransformMakeTranslation(0, -50);
            } completion:^(BOOL finished) {
                self.piaopiaoLabel.hidden = YES;
                self.piaopiaoLabel.transform = CGAffineTransformIdentity;
            }];
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
