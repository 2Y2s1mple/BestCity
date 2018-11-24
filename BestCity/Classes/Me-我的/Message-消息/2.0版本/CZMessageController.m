//
//  CZMessageController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.

#import "CZMessageController.h"
#import "CZNavigationView.h"
#import "Masonry.h"
#import "CZMessageCell.h"
#import "CZSystemMessageController.h"
#import "CZTestWinController.h"
#import "CZMessageActivityController.h"

@interface CZMessageController ()<UITableViewDataSource, UITableViewDelegate>
/** 顶部的视图 */
@property (nonatomic, strong) UIView *topView;
/** 内容数据 */
@property (nonatomic, strong) NSArray *messages;
/** 内容视图 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZMessageController

- (NSArray *)messages
{
    if (_messages == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CZMessageData.plist" ofType:nil];
        _messages = [NSArray arrayWithContentsOfFile:path];
    }
    return _messages;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"消息" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    //加载推送开启监听的视图
    [self setupTopView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

//推送开启的视图
- (void)setupTopView
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:topView];
    self.topView = topView;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(68);
        make.height.equalTo(@50);
    }];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"开启系统通知，精彩消息不容错过";
    topLabel.textColor = CZGlobalGray;
    topLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(20);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"去开启" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 13;
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [topView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topLabel.mas_right).offset(20);
        make.width.equalTo(@60);
        make.height.equalTo(@24);
    }];
    
    UIButton *wrongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wrongBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    wrongBtn.userInteractionEnabled = NO;
    [topView addSubview:wrongBtn];
    [wrongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView).offset(-20);
        make.width.height.equalTo(@30);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.topView.hidden = YES;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(68);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMessageCell *cell = [CZMessageCell cellWithTabelView:tableView];
    cell.messages = self.messages[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            CZSystemMessageController *vc = [[CZSystemMessageController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            CZMessageActivityController *vc = [[CZMessageActivityController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            CZTestWinController *vc = [[CZTestWinController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}







@end
