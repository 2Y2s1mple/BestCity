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
#import "GXNetTool.h"
#import "MJExtension.h"
#import "CZRecommendListModel.h"

@interface CZHotsaleSearchDetailController ()<UITextFieldDelegate>
@end

@implementation CZHotsaleSearchDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取数据
    [self getSourceData];
    //设置搜索栏
    UIView *searchView = [self setupTopViewWithFrame:CGRectMake(0, 30, SCR_WIDTH, 34)];
    
    self.tableView.frame = CGRectMake(0, FSS(35) + 40, SCR_WIDTH, SCR_HEIGHT - CGRectGetMaxY(searchView.frame) - 10);
}

- (void)getSourceData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsName"] = self.textTitle;
    
    [CZProgressHUD showProgressHUDWithText:nil];
    //获取数据
    [GXNetTool GetNetWithUrl:[SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/searchGoods"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSLog(@"%@", result);
            self.dataSource = [CZRecommendListModel objectArrayWithKeyValuesArray:result[@"list"]];
            [self.tableView reloadData];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}


#pragma mark - 创建搜索框以及方法
- (UIView *)setupTopViewWithFrame:(CGRect)frame
{
    UIView *topView = [[UIView alloc] initWithFrame:frame];
    topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.backgroundColor = [UIColor redColor];
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
    textField.rightView = button;
    textField.rightViewMode = UITextFieldViewModeAlways;
    return topView;
}

- (void)clearBtnaction
{
    [self.delegate HotsaleSearchDetailController:self isClear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate HotsaleSearchDetailController:self isClear:NO];
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

- (void)cancleAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

    //push到详情
//    CZOneDetailController *vc = [[CZOneDetailController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//        TSLWebViewController *vc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://192.168.5.178:8080/ueditor/goodDetail/goodId_197382787/top-info/info-tab.html"]];
//        [self.navigationController pushViewController:vc animated:YES];

@end
