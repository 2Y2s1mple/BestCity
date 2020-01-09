//
//  CZBuyView.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZBuyView.h"
#import "Masonry.h"
#import "CZBuyViewCell.h"
#import "CZOpenAlibcTrade.h"
#import "TSLWebViewController.h"
#import "CZUserInfoTool.h"
#import "GXNetTool.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>

@interface CZBuyView () <UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIView *contentView;
@end

@implementation CZBuyView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView 
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(SCR_WIDTH));
        make.height.equalTo(@(SCR_HEIGHT));
    }]; 
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.equalTo(@(SCR_WIDTH));
        make.height.equalTo(@(339));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"相关商品";
    title.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(12);
        make.left.equalTo(contentView).offset(14);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(contentView).offset(-14);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [contentView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(12);
        make.right.equalTo(@(-14));
        make.left.equalTo(@(14));
        make.bottom.equalTo(self);
        
    }];
}

- (void)setBuyDataList:(NSArray *)buyDataList
{
    _buyDataList = buyDataList;
    if (buyDataList.count == 1) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.equalTo(@(339 - 150));
        }];
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"buyViewCellIdentifier";
    CZBuyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZBuyViewCell class]) owner:nil options:nil] firstObject];
    }
    cell.buyDataDic = self.buyDataList[indexPath.row];
    return cell;    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buyDataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.buyDataList[indexPath.row];
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *naVc = tabbar.selectedViewController;
    UIViewController *toVC = naVc.topViewController;
    NSString *specialId = [NSString stringWithFormat:@"%@", JPUSERINFO[@"relationId"]];
    if ([specialId isEqualToString:@"(null)"]) {
        [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
        [[ALBBSDK sharedInstance] auth:toVC successCallback:^(ALBBSession *session) {
            NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
            NSLog(@"%@", tip);
            TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@""] actionblock:^{
                [CZProgressHUD showProgressHUDWithText:@"授权成功"];
                [CZProgressHUD hideAfterDelay:1.5];
                [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];
            }];
            [vc presentViewController:webVc animated:YES completion:nil];

            //拉起淘宝
            AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
            showParam.openType = AlibcOpenTypeAuto;
            showParam.backUrl = @"tbopen25267281://xx.xx.xx";
            showParam.isNeedPush = YES;
            showParam.nativeFailMode = AlibcNativeFailModeJumpH5;

            [CZProgressHUD hideAfterDelay:1.5];

            [[AlibcTradeSDK sharedInstance].tradeService
             openByUrl:[NSString stringWithFormat:@"https://oauth.m.taobao.com/authorize?response_type=code&client_id=25612235&redirect_uri=https://www.jipincheng.cn/qualityshop-api/api/taobao/returnUrl&state=%@&view=wap", JPTOKEN]
             identity:@"trade"
             webView:webVc.webView
             parentController:vc
             showParams:showParam
             taoKeParams:nil
             trackParam:nil
             tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                 NSLog(@"-----AlibcTradeSDK------");
                 if(result.result == AlibcTradeResultTypeAddCard){
                     NSLog(@"交易成功");
                 } else if(result.result == AlibcTradeResultTypeAddCard){
                     NSLog(@"加入购物车");
                 }
             } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                 NSLog(@"----------退出交易流程----------");
             }];
        } failureCallback:^(ALBBSession *session, NSError *error) {
            NSString *tip=[NSString stringWithFormat:@"登录失败:%@",@""];
            NSLog(@"%@", tip);
        }];
    } else {
        NSLog(@"已经登录了");
        // 打开淘宝
        [self openAlibcTradeWithId:dic[@"goodsId"]];
    }
}

- (void)openAlibcTradeWithId:(NSString *)ID
{
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsId"] = ID;
    //获取详情数据
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsBuyLink"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:result[@"data"] parentController:vc];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"接口错误"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}


- (void)dismiss
{
    [self removeFromSuperview];
}

@end
