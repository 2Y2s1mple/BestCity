//
//  CZSettingController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSettingController.h"
#import "CZNavigationView.h"
#import "CZSettingCell.h"
#import "CZfeedbackController.h"
#import "TSLWebViewController.h"
#import "SDImageCache.h"
#import "CZAlertViewTool.h"
#import "GXNetTool.h"
#import "CZAddressController.h"
#import "CZChangeWeChatController.h"
#import "CZUserInfoTool.h"
#import "CZAboutJIPinChengController.h"

@interface CZSettingController ()<UITableViewDelegate, UITableViewDataSource>
/** 标题数组 */
@property (nonatomic, strong) NSArray *contentTitles;
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZSettingController
- (NSArray *)contentTitles
{
    if (_contentTitles == nil) {
        _contentTitles = @[@"收货地址", @"微信", @"我要反馈", @"清除缓存", @"客服微信", @"鼓励一下", @"关于极品城"];
    }
    return _contentTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 初始化界面内容
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {

    }];
}

#pragma mark - 设置界面
- (void)setupView
{
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"设置" rightBtnTitle:nil rightBtnAction:nil];
    [self.view addSubview:navigationView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68 + (IsiPhoneX ? 24 : 0), SCR_WIDTH, SCR_HEIGHT - 68 - (IsiPhoneX ? 24 : 0)) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //底部退出按钮
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(0, SCR_HEIGHT - 50 - (IsiPhoneX ? 34 : 0), SCR_WIDTH, 50);
    [self.view addSubview:loginOut];
    [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = CZREDCOLOR;
    [loginOut addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
}

/** 退出登录 */
- (void)loginOutAction
{
    [CZAlertViewTool showAlertWithTitle:@"确认退出" action:^{
        // 参数
        NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/logout"];
        // 请求
        [GXNetTool PostNetWithUrl:url body:@{} bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {} failure:^(NSError *error) {}];
        // 删除用户信息
        [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"user"];
        // 删除token
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];

        [[NSUserDefaults standardUserDefaults] synchronize];
        // 返回上一页
        CZLoginController *vc = [CZLoginController shareLoginController];
        vc.isLogin = NO;
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
    }];
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZSettingCell *cell = [CZSettingCell cellWithTabelView:tableView];
    cell.title = self.contentTitles[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            /** 添加地址 */
            CZAddressController *vc = [[CZAddressController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            /** 微信 */
            CZChangeWeChatController *vc = [[CZChangeWeChatController alloc] init];
            vc.name = JPUSERINFO[@"wechat"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            /** 跳转到反馈 */
            CZfeedbackController *vc = [[CZfeedbackController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            [CZAlertViewTool showSheetAlertAction:^{
                //响应事件
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [CZProgressHUD showProgressHUDWithText:@"清理成功"];
                    [CZProgressHUD hideAfterDelay:0.25];
                    [self.tableView reloadData];;
                }];
            }];
        }
            break;
        case 4:
        {
            [CZAlertViewTool showAlertWithTitle:[@"官方客服微信: " stringByAppendingString:JPUSERINFO[@"officialWeChat"]] actionBtns:@[@"取消", @"复制"] action:^{
                UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
                posteboard.string = JPUSERINFO[@"officialWeChat"];
                [CZProgressHUD showProgressHUDWithText:@"复制成功"];
                [CZProgressHUD hideAfterDelay:1.5];
                [recordSearchTextArray addObject:posteboard.string];
            }];
        }
            break;
        case 5:
        {
            // 跳转App Store评分
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1450707933&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
            break;
        }
        case 6:
        {
            /** 关于极品城 */
            CZAboutJIPinChengController *vc = [[CZAboutJIPinChengController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }
}

@end
