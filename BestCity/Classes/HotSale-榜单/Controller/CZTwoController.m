//
//  CZTwoController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZTwoController.h"
#import "CZHotSaleCell.h"
#import "CZOneDetailController.h"


@interface CZTwoController ()<UITableViewDelegate, UITableViewDataSource>
/** 记录高度 */
@property (nonatomic, assign) CGFloat recordHeight;
/** 记录点击的按钮 */
@property (nonatomic, strong) UIButton *recordBtn;
@end

@implementation CZTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    
    [self setupHeaderView];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _recordHeight, SCR_WIDTH, SCR_HEIGHT - HOTContentY - 49 - _recordHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
//    tableView.tableHeaderView = [self setupHeaderView];
}

- (void)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 180)];
    backView.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:backView];
    CGFloat x = 0;
    CGFloat y = 10;
    CGFloat w = SCR_WIDTH / 6;
    CGFloat h = 20;
    
    NSArray *titles = @[@"剃须刀", @"计步器", @"吹风机", @"足浴盆", @"体重计", @"剃/脱毛器", @"美容仪", @"按摩椅", @"理发器", @"电动牙刷"];
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x + ((i % 6) * w), y + ((i / 6) * (h + 20)), w, h);
//        btn.backgroundColor = RANDOMCOLOR;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:CZREDCOLOR forState:UIControlStateSelected];
        [btn setTitleColor:CZGlobalGray forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [backView addSubview:btn];
    }
    UIButton *btn = (UIButton *)[[backView subviews] lastObject];
    _recordHeight = CZGetY(btn) + 10;
    backView.frame = CGRectMake(0, 0, SCR_WIDTH, _recordHeight);
    
}

- (void)didClickedBtn:(UIButton *)sender
{
    _recordBtn.selected = NO;
    sender.selected = YES;
    NSLog(@"点击了第%ld个按钮", sender.tag);
    

    _recordBtn = sender;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FSS(515);
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"hotSaleCell";
    CZHotSaleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZHotSaleCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push到详情
    CZOneDetailController *vc = [[CZOneDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    //    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://192.168.5.186:8080/ea_cs_tmall_app/showhistory"]];
    //    [self.navigationController pushViewController:vc animated:YES];
}


@end
