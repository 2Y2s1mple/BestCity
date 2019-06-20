//
//  CZTrialTestListController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialTestListController.h"
#import "UIButton+WebCache.h"
#import "CZSubButton.h"
#import "CZMutContentButton.h"
#import "CZTrailTestCell.h"

#import "CZvoteUserController.h"
#import "CZReportAllListController.h"


@interface CZTrialTestListController () <UITableViewDelegate, UITableViewDataSource>
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLbel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackViewTop;

@property (nonatomic, strong) UITableView *tableView;

/** 拉赞 */
@property (nonatomic, assign) NSInteger listCount;


@end

@implementation CZTrialTestListController
- (UITableView *)tableView
{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CZGetY([self.view.subviews lastObject]), SCR_WIDTH, 300) style:UITableViewStylePlain];
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //2进行中 3试用中，4结束
    NSString *status = self.dataSource[@"status"];
    if ([status isEqual:@(2)]) {
        self.topView.hidden = YES;
        self.topViewHeight.constant = 0;
        self.topBackViewTop.constant = -68;
        self.tableView.y -= 68;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"试用名单暂未公布 ";
        titleLabel.textColor = CZGlobalGray;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(self.topBackView.width / 2.0, self.topBackView.height / 2.0);
        [self.topBackView addSubview:titleLabel];
    } else {    
        NSString *text = [NSString stringWithFormat:@"请以下用户于 %@ 前完成试用报告", self.dataSource[@"reportEndTime"]];
        self.titleLbel.textColor = UIColorFromRGB(0x151515);
        self.titleLbel.attributedText = [text addAttributeColor:CZREDCOLOR Range:[text rangeOfString:self.dataSource[@"reportEndTime"]]];
        NSArray *list = self.dataSource[@"passedUserList"];
        NSInteger count = 0;
        if (list.count >= 6) {
            count = 6;
            CZMutContentButton *rightBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setTitle:@"查看全部" forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:@"right-blue"] forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
            [rightBtn setTitleColor:UIColorFromRGB(0x4A90E2) forState:UIControlStateNormal];
            [self.topBackView addSubview:rightBtn];
            [rightBtn sizeToFit];
            rightBtn.centerX = self.topBackView.width / 2.0;
            rightBtn.y = self.topBackView.height - 40;
            [rightBtn addTarget:self action:@selector(checkVoteUser) forControlEvents:UIControlEventTouchUpInside];
        } else if (list.count < 6) {
            count = list.count;
        }
        
        for (int i = 0; i < count; i++) {
            UIView *backView = [[UIView alloc] init];
            CZSubButton *btn = [CZSubButton buttonWithType:UIButtonTypeCustom];
            [btn sd_setImageWithURL:[NSURL URLWithString:list[i][@"userAvatar"]] forState:UIControlStateNormal];
            [btn setTitle:list[i][@"userNickname"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [backView addSubview:btn];
            
            backView.height = self.topBackView.height / 3.0;
            backView.width = SCR_WIDTH / 3.0;
            backView.x = (i % 3) * (SCR_WIDTH / 3.0);
            backView.y = (i / 3) * backView.height;
            
            btn.size = CGSizeMake(40, 40);
            btn.center = CGPointMake(backView.width / 2.0, backView.height / 2.0);
            btn.imageView.layer.cornerRadius = btn.width / 2.0;
            btn.imageView.layer.masksToBounds = YES;
            
            [self.topBackView addSubview:backView];
        }
    }
    
    
    [self setupTopView];
    self.view.x = 0;
    self.view.width = SCR_WIDTH;
    self.view.height = CZGetY([self.view.subviews lastObject]);
}



- (void)setupTopView
{
    
    self.listCount = [self.dataSource[@"applyUserList"] count];
    if (self.listCount > 7) {
        self.listCount = 7;
        self.tableView.height = self.listCount * 72;
        CZMutContentButton *rightBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"right-blue"] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
        [rightBtn setTitleColor:UIColorFromRGB(0x4A90E2) forState:UIControlStateNormal];
        [self.view addSubview:rightBtn];
        [rightBtn sizeToFit];
        rightBtn.centerX = self.topBackView.width / 2.0;
        rightBtn.y = CZGetY(self.tableView) + 20;
        [rightBtn addTarget:self action:@selector(checkAllReport) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.listCount == 7) {
        self.tableView.height = self.listCount * 72;
    } else {
        self.tableView.height = self.listCount * 72;
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.y = CZGetY([self.view.subviews lastObject]) + 20;
    lineView.height = 6;
    lineView.width = SCR_WIDTH;
    [self.view addSubview:lineView];
    lineView.backgroundColor = CZGlobalLightGray;
}

// <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTrailTestCell *cell = [CZTrailTestCell cellWithTableView:tableView];
    cell.numbersLabel.text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1)];
    cell.dic = self.dataSource[@"applyUserList"][indexPath.row];
    return cell;
}

// <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


- (void)checkVoteUser
{
    CZvoteUserController *vc = [[CZvoteUserController alloc] init];
    vc.dataSource = self.dataSource;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)checkAllReport
{
    CZReportAllListController *vc = [[CZReportAllListController alloc] init];
    vc.dataSource = self.dataSource;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

@end
