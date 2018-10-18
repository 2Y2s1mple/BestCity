//
//  CZSystemMessageController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSystemMessageController.h"
#import "CZNavigationView.h"
#import "Masonry.h"
#import "CZSystemMessageCell.h"
#import "CZSystemMessageDetailController.h"

@interface CZSystemMessageController ()<UITableViewDelegate, UITableViewDataSource>
/** 内容数据 */
@property (nonatomic, strong) NSArray *messages;
@end

@implementation CZSystemMessageController
- (NSArray *)messages
{
    if (_messages == nil) {
        _messages = @[@"京东返利升级", @"支付宝返利升级"];
    }
    return _messages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"系统消息" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(68);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZSystemMessageCell *cell = [CZSystemMessageCell cellWithTabelView:tableView];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZSystemMessageDetailController *vc = [[CZSystemMessageDetailController alloc] init];
    vc.vcTitle = self.messages[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
