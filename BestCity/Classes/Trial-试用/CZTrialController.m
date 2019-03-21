//
//  CZTrialController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialController.h"
#import "CZNavigationView.h"
#import "CZTrialMainCell.h"

@interface CZTrialController () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *trialDatasArr;
@end

@implementation CZTrialController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"全部试用" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    

}


// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
@end
