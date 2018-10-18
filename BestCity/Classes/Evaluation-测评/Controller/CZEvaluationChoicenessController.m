//
//  CZEvaluationChoicenessController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZEvaluationChoicenessController.h"
#import "CZEvaluationChoicenessCell.h"

@interface CZEvaluationChoicenessController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CZEvaluationChoicenessController

- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCR_WIDTH, SCR_HEIGHT - 71 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor greenColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CZEvaluationChoicenessCell *cell = [CZEvaluationChoicenessCell cellWithTableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 454;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

@end
