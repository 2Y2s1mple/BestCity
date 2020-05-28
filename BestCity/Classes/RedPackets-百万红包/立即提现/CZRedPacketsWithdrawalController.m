//
//  CZRedPacketsWithdrawalController.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsWithdrawalController.h"
#import "CZNavigationView.h"
#import "CZRedPacketsWithdrawalView.h"
#import "GXNetTool.h"
#import "CZRWBindingController.h"

UIKIT_EXTERN NSString *moneyCount;

@interface CZRedPacketsWithdrawalController ()
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) CZRedPacketsWithdrawalView *withdrawalView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *synchronizeModel;

@end

@implementation CZRedPacketsWithdrawalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"提现" rightBtnTitle:nil rightBtnAction:nil ];
    navigationView.backgroundColor = CZGlobalWhiteBg;
    [self.view addSubview:navigationView];

    // 创建滚动视图
    [self.view addSubview:self.scrollView];
    
    [self createSubViews];

    //底部退出按钮
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(0, SCR_HEIGHT - 50, SCR_WIDTH, 50);
    [self.view addSubview:loginOut];
    [loginOut setTitle:@"立即提现" forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = CZREDCOLOR;
    [loginOut addTarget:self action:@selector(withdrawal) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDataSource];
}

#pragma mark - 创建UI
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.y = (IsiPhoneX ? 24 : 0) + 67;
        _scrollView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT - _scrollView.y);
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)createSubViews
{
    CZRedPacketsWithdrawalView *vc = [CZRedPacketsWithdrawalView redPacketsWithdrawalView];
    [self.scrollView addSubview:vc];
    vc.model = self.model;
    self.withdrawalView = vc;

    CGFloat maxHeight = CZGetY([self.scrollView.subviews lastObject]);
    self.scrollView.contentSize = CGSizeMake(0, maxHeight);
}

/** 提现 */
- (void)withdrawal
{
    self.model = self.synchronizeModel;
    if ([self.model[@"alipayNickname"] length] > 0) {
        if (moneyCount.length > 0) {
            NSString *message = [NSString stringWithFormat:@"是否提现到支付宝账户%@", self.model[@"alipayNickname"]];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/withdraw"];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"amount"] = moneyCount;
                [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
                    if ([result[@"code"] isEqual:@(0)]) {
                        [CZProgressHUD showProgressHUDWithText:@"提现成功"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    } else {
                        [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
                    }
                    // 取消菊花
                    [CZProgressHUD hideAfterDelay:1.5];
                } failure:nil];
            }]];
            [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"请选择提现金额"];
            // 取消菊花
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } else {
        [CZProgressHUD showProgressHUDWithText:@"请绑定支付宝"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
}

#pragma mark - 同步数据
- (void)getDataSource
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/v2/hongbao/getWithdrawInfo"];
//    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/index"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.withdrawalView.model = result[@"data"];
            self.synchronizeModel = result[@"data"];
        }
    } failure:^(NSError *error) {

    }];
}



@end
