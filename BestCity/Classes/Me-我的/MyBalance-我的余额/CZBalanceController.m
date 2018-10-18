//
//  CZBalanceController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/2.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZBalanceController.h"
#import "CZNavigationView.h"
#import "CZCreditorController.h"
#import "CZMoneySourceController.h"
#import "GXNetTool.h"
#import "CZProgressHUD.h"
#import "DLIDEKeyboardView.h"
#import "CZMyPointDetailController.h"

@interface CZBalanceController () <CZCreditorControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
/** 总钱数 */
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
/** 处理中 */
@property (weak, nonatomic) IBOutlet UILabel *beingProcessed;
/** 可提现 */
@property (weak, nonatomic) IBOutlet UILabel *withdraw;
/** 待结算 */
@property (weak, nonatomic) IBOutlet UILabel *settleAccount;
/** 已提现 */
@property (weak, nonatomic) IBOutlet UILabel *afterSettleAccount;
/** 提现金额 */
@property (weak, nonatomic) IBOutlet UITextField *amountTextFiled;
/** 支付宝账号 */
@property (nonatomic, weak) IBOutlet UILabel *alipayAccountLabel;
/** 下面辅助显示的金额 */
@property (nonatomic, weak) IBOutlet UILabel *assistLabel;
/** 全部提现 */
@property (nonatomic, weak) IBOutlet UILabel *allWithdrawLabel;


@end

@implementation CZBalanceController

#pragma mark - 跳转到佣金来源
- (IBAction)moneySource:(id)sender {
    CZMoneySourceController *vc = [[CZMoneySourceController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转到绑定支付宝
- (IBAction)pushCreditor:(id)sender {
    CZCreditorController *vc= [[CZCreditorController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 申请提现
- (IBAction)applyAmount
{
    if ([self.amountTextFiled.text floatValue] < 50) {
        [CZProgressHUD showProgressHUDWithText:@"最低提现金额为50元"];
        [CZProgressHUD hideAfterDelay:2];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"real_name"] = @"**旬";
//    param[@"phone"] = @"13841284944";
    param[@"amount"] = self.amountTextFiled.text;
    param[@"real_name"] = ALIPAYPREALNAME;
    param[@"phone"] = ALIPAYPhone;
    
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/lipay"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"提现成功"]) {
            [CZProgressHUD showProgressHUDWithText:@"提现成功"];
            // 获取佣金
            [self getBalance];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        [CZProgressHUD hideAfterDelay:2];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 67) title:@"我的佣金" rightBtnTitle:@"提现记录" rightBtnAction:^{
        NSLog(@"%@", @"提现记录");
        CZMyPointDetailController *vc = [[CZMyPointDetailController alloc] init];
        vc.titleName = @"提现记录";
        [self.navigationController pushViewController:vc animated:YES];
    } navigationViewType:CZNavigationViewTypeWhite];
    [self.view addSubview:navigationView];
    
    NSString *defaultString = @"温馨提示: 最低提现金额为50元, 24小时内到账";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:defaultString];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[defaultString rangeOfString:@"50"]];
    self.bottomLabel.attributedText = string;
    
    // 设置提现金额的键盘样式
    self.amountTextFiled.keyboardType = UIKeyboardTypeDecimalPad;
    [DLIDEKeyboardView attachToTextView:self.amountTextFiled];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.text = @"¥";
    label.font = [UIFont systemFontOfSize:23];
    self.amountTextFiled.leftView = label;
    self.amountTextFiled.leftViewMode = UITextFieldViewModeAlways;
    
    // 设置全部提现的响应方法
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWithdrawAction)];
    self.allWithdrawLabel.userInteractionEnabled = YES;
    [self.allWithdrawLabel addGestureRecognizer:tap];
    
    // 判断是否需要绑定支付宝
    if (ALIPAYPhone == nil) {
        self.alipayAccountLabel.text = @"请绑定支付宝账号";
    } else {
        self.alipayAccountLabel.text = [@"支付宝账号: " stringByAppendingString:ALIPAYPhone];
    }

    // 获取佣金
    [self getBalance];
}

#pragma mark - 全部提现
- (void)allWithdrawAction
{
    NSLog(@"%s", __FUNCTION__);
    self.amountTextFiled.text = self.withdraw.text;
}

#pragma mark - 获取佣金
- (void)getBalance
{
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = USERINFO[@"userId"];
    NSString *url = [SERVER_URL stringByAppendingPathComponent:@"qualityshop-api/api/account"];
    // 请求
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSLog(@"%@", result);
            // 赋值
            [self setupMoney:[result[@"list"] firstObject]];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"无数据"];
            [CZProgressHUD hideAfterDelay:2];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupMoney:(NSDictionary *)result
{
    // 总金额
    NSString *total = [self changeStr:result[@"total_account"]];
    // 已体现
    NSString *afterAccount = [self changeStr:result[@"use_account"]];
    
    self.totalMoney.text = [@"总佣金¥" stringByAppendingString:total];
    self.beingProcessed.text = result[@"state"];
    self.withdraw.text = total;
    self.settleAccount.text = @"0";
    self.afterSettleAccount.text = afterAccount;
    
    // 辅助显示的余额
    self.assistLabel.text = [@"余额¥" stringByAppendingString:total];;
}

- (NSString *)changeStr:(id)value
{
    return [NSString stringWithFormat:@"%0.2f", [value floatValue]];
}

#pragma mark - <CZCreditorControllerDelegate>
- (void)updateData
{
    self.alipayAccountLabel.text = ALIPAYPhone;
}

@end
