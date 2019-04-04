//
//  CZCommonRecommendController.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCommonRecommendController.h"
#import "CZCommonRecommendCell.h"

@interface CZCommonRecommendController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CZCommonRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setup];
    
    self.view.height = CZGetY([self.view.subviews lastObject]) + 50; 
}

- (void)setup
{
    
    CGFloat space = 14.0f;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 150, 20)];
    titleLabel.text = @"相关推荐";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [self.view addSubview:titleLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(titleLabel.x, CZGetY(titleLabel) + 24, SCR_WIDTH - 2 * titleLabel.x, 200) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZCommonRecommendCell *cell = [CZCommonRecommendCell cellWithTableView:tableView];
    return cell;
}
@end
