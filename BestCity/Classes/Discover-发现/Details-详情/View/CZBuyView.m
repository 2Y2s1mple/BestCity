//
//  CZBuyView.m
//  BestCity
//
//  Created by JasonBourne on 2019/1/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZBuyView.h"
#import "Masonry.h"
#import "CZBuyViewCell.h"
#import "CZOpenAlibcTrade.h"

@interface CZBuyView () <UITableViewDelegate, UITableViewDataSource>
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIView *contentView;
@end

@implementation CZBuyView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView 
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(SCR_WIDTH));
        make.height.equalTo(@(SCR_HEIGHT));
    }]; 
    
    UIView *contentView = [[UIView alloc] init];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.equalTo(@(SCR_WIDTH));
        make.height.equalTo(@(339));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"相关商品";
    title.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    [contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(12);
        make.left.equalTo(contentView).offset(14);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close-1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(contentView).offset(-14);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [contentView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(12);
        make.right.equalTo(@(-14));
        make.left.equalTo(@(14));
        make.bottom.equalTo(self);
        
    }];
}

- (void)setBuyDataList:(NSArray *)buyDataList
{
    _buyDataList = buyDataList;
    if (buyDataList.count == 1) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.equalTo(@(339 - 150));
        }];
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"buyViewCellIdentifier";
    CZBuyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZBuyViewCell class]) owner:nil options:nil] firstObject];
    }
    cell.buyDataDic = self.buyDataList[indexPath.row];
    return cell;    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buyDataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.buyDataList[indexPath.row];
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
    // 打开淘宝
    [CZOpenAlibcTrade openAlibcTradeWithUrlString:dic[@"goodsBuyLink"] parentController:vc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}


- (void)dismiss
{
    [self removeFromSuperview];
}

@end
