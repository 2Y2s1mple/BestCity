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

@interface CZSettingController ()<UITableViewDelegate, UITableViewDataSource>
/** 标题数组 */
@property (nonatomic, strong) NSArray *contentTitles;
@end

@implementation CZSettingController
- (NSArray *)contentTitles
{
    if (_contentTitles == nil) {
        _contentTitles = @[@"我要反馈", @"清除缓存", @"联系客服", @"鼓励一下", @"用户协议"];
    }
    return _contentTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"设置" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCR_WIDTH, SCR_HEIGHT - 68) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    //底部退出按钮
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(0, SCR_HEIGHT - 50, SCR_WIDTH, 50);
    [self.view addSubview:loginOut];
    [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOut.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOut.backgroundColor = CZRGBColor(227, 20, 54);
    [loginOut addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
}

/** 退出登录 */
- (void)loginOutAction
{
    NSLog(@"-------");
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
            /** 跳转到反馈 */
            CZfeedbackController *vc = [[CZfeedbackController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            /** 清除缓存 */
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      
                                                                  }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 4:
        {
            /** 跳转到用户协议 */
            TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:UserAgreement_url]];
            webVc.titleName = @"用户协议";
            [self.navigationController pushViewController:webVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
