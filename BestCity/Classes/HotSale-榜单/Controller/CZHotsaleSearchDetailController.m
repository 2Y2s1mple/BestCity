//
//  CZHotsaleSearchDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZHotsaleSearchDetailController.h"
#import "CZTextField.h"
#import "CZHotSaleCell.h"
#import "CZOneDetailController.h"
#import "Masonry.h"
#import "TSLWebViewController.h"

@interface CZHotsaleSearchDetailController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end

@implementation CZHotsaleSearchDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalBg;
    //设置搜索栏
    [self setupTopViewWithFrame:CGRectMake(0, 30, SCR_WIDTH, FSS(34))];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FSS(35) + 40, SCR_WIDTH, SCR_HEIGHT - 49 - FSS(35) - 40) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

- (void)setupTopViewWithFrame:(CGRect)frame
{
    UIView *topView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:topView];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [topView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(20);
        make.width.equalTo(@(FSS(40)));
        make.height.equalTo(@(FSS(17)));
    }];

    CZTextField *textField = [[CZTextField alloc] init];
    [topView addSubview:textField];
    textField.font = [UIFont systemFontOfSize:14];
    textField.layer.cornerRadius = 17;
    textField.layer.borderColor = UIColorFromRGB(0xACACAC).CGColor ;
    textField.layer.borderWidth = 0.5;
    textField.delegate = self;
    textField.text = self.textTitle;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView).offset(-20);
        make.left.equalTo(leftBtn.mas_right).offset(0);
        make.height.equalTo(@(topView.height));
    }];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-search"]];
    textField.leftView = image;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"search-close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearBtnaction) forControlEvents:UIControlEventTouchUpInside];
//    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.rightView = button;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
}

- (void)clearBtnaction
{
    NSLog(@"clearBtnaction");
    [self.delegate HotsaleSearchDetailController:self isClear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");
    [self.delegate HotsaleSearchDetailController:self isClear:NO];
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}


- (void)cancleAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
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
//    CZOneDetailController *vc = [[CZOneDetailController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
        TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://192.168.5.178:8080/ueditor/goodDetail/goodId_197382787/top-info/info-tab.html"]];
        [self.navigationController pushViewController:vc animated:YES];
}

@end
