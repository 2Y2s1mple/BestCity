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

UIKIT_EXTERN NSString *moneyCount;

@interface CZRedPacketsWithdrawalController ()
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;

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

    CGFloat maxHeight = CZGetY([self.scrollView.subviews lastObject]);
    self.scrollView.contentSize = CGSizeMake(0, maxHeight);
}

/** 提现 */
- (void)withdrawal
{
    if ([self.model[@"alipayNickname"] length] > 0) {

    } else {
        [CZProgressHUD showProgressHUDWithText:@"请绑定支付宝"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    if (moneyCount.length > 0) {
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/withdraw"];
           NSMutableDictionary *param = [NSMutableDictionary dictionary];
           param[@"amount"] = moneyCount;
           [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
               if ([result[@"code"] isEqual:@(0)]) {

               } else {
                   [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
               }
               // 取消菊花
               [CZProgressHUD hideAfterDelay:1.5];
           } failure:nil];
    } else {
        [CZProgressHUD showProgressHUDWithText:@"请选择提现金额"];
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    }


}



@end
