//
//  CZTrialMainController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialMainController.h"
#import "CZMutContentButton.h"
#import "CZTrialMainCell.h"
#import "CZTrialController.h"

@interface CZTrialMainController () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *trialDatasArr;
@end

@implementation CZTrialMainController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 44 : 20), SCR_WIDTH, SCR_HEIGHT - (IsiPhoneX ? 44 : 20) - (IsiPhoneX ? 83 : 49)) style:UITableViewStylePlain];
        self.tableView.backgroundColor = CZGlobalLightGray;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)trialDatasArr
{
    if (_trialDatasArr == nil) {
        _trialDatasArr = [NSMutableArray array];
    }
    return _trialDatasArr;
}


#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 表
    [self.view addSubview:self.tableView];
}




#pragma mark - 视图初始化
- (UIView *)setupTopNavView:(NSString *)title
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 47)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    navLabel.text = title;
    [navigationView addSubview:navLabel];
    navLabel.x = 14;
    navLabel.height = 23;
    navLabel.y = navigationView.height - 23 - 12;
    [navLabel sizeToFit];
    
    CZMutContentButton *rightBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"right-blue"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    [rightBtn setTitleColor:UIColorFromRGB(0x4A90E2) forState:UIControlStateNormal];
    [navigationView addSubview:rightBtn];
    [rightBtn sizeToFit];
    rightBtn.x = navigationView.width - 80;
    rightBtn.centerY = navLabel.centerY;
    if ([title isEqualToString:@"免费试用"]) {
        [rightBtn addTarget:self action:@selector(moreTrialDatas:) forControlEvents:UIControlEventTouchUpInside];
        return navigationView;
    } else {
        [rightBtn addTarget:self action:@selector(moreTrialReport:) forControlEvents:UIControlEventTouchUpInside];
        return navigationView;
    }
    return navigationView;
}

#pragma mark - 事件
- (void)moreTrialDatas:(UIButton *)sender
{
    NSLog(@"试用");
    CZTrialController *vc = [[CZTrialController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreTrialReport:(UIButton *)sender
{
    NSLog(@"报告");
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrialMainCell *cell = [CZTrialMainCell cellWithTableView:tableView];
    NSLog(@"%@", cell);
    return cell;
}



// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self setupTopNavView:@"免费试用"];
        case 1 :
            return [self setupTopNavView:@"试用报告"];
        default:
            return [self setupTopNavView:@""];
    }
    
}


@end
