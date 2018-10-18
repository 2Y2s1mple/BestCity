//
//  CZOneController.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZOneController.h"
#import "CZHotSaleCell.h"
#import "CZOneDetailController.h"

//测试
#import "TSLWebViewController.h"
#import "UIImageView+WebCache.h"

@interface CZOneController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CZOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    //line
    CZTOPLINE;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCR_WIDTH, SCR_HEIGHT - HOTContentY - 49 - 10) style:UITableViewStylePlain];
     if (@available(iOS 11.0, *)) {
         tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.tableHeaderView = [self setupHeaderView];
    
    NSLog(@"%@", self.dataDic);
}

- (UIView *)setupHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, FSS(180))];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"logoimg"]] placeholderImage:[UIImage imageNamed:@"banner"]];
    imageView.frame = CGRectMake(10, 10, SCR_WIDTH - 20, backView.height - 10);
    [backView addSubview:imageView];
    
    return backView;
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
    vc.selectIndex = 0;
    vc.menuViewStyle = WMMenuViewStyleLine;
    vc.automaticallyCalculatesItemWidths = YES;
    //        hotVc.titleFontName = @"PingFangSC-Medium";
    vc.titleColorNormal = CZGlobalGray;
    vc.titleColorSelected = CZRGBColor(5, 5, 5);
    vc.titleSizeNormal = 16.0f;
    vc.titleSizeSelected = vc.titleSizeNormal;
    vc.progressColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
    
//    TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://192.168.5.186:8080/ea_cs_tmall_app/showhistory"]];
//    [self.navigationController pushViewController:vc animated:YES];
}



@end
