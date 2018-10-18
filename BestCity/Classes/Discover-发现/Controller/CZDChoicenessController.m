//
//  CZDChoicenessController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZDChoicenessController.h"
#import "CZChoicenessCell.h"
#import "CZDChoiceDetailController.h"

@interface CZDChoicenessController ()<UITableViewDelegate, UITableViewDataSource>
/** tabelview */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CZDChoicenessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    //line
    CZTOPLINE;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, SCR_HEIGHT - 71 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor greenColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZChoicenessCell *cell = [CZChoicenessCell cellwithTableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
