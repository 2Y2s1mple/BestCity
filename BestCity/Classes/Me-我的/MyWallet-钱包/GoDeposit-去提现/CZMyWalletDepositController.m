//
//  CZMyWalletDepositController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletDepositController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "CZGotoScoreView.h"

@interface CZMyWalletDepositController ()<UITextFieldDelegate>
/** 最上面的背景图 */
@property (nonatomic, weak) IBOutlet UIView *topView;
/** 总金额 */
@property (nonatomic, weak) IBOutlet UILabel *totalPeiceLabel;
/** 真实姓名 */
@property (nonatomic, weak) IBOutlet UITextField *realNameTextField;
@property (nonatomic, weak) IBOutlet UILabel *realNamePlaceHolder;
/** 支付宝账号 */
@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UILabel *accountPlaceHolder;
/** 提现金额 */
@property (nonatomic, weak) IBOutlet UITextField *withdrawTextField;

@property (weak, nonatomic) IBOutlet UILabel *notelabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *maxMoney;

@end

@implementation CZMyWalletDepositController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalLightGray;
    // 获取数据
    [self getNoteData];
    [self getALPayAccount];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我要提现" rightBtnTitle:nil rightBtnAction:nil ];
    [self.view addSubview:navigationView];

    self.topView.layer.cornerRadius = 5;
    self.topView.layer.shadowColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1.0].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 4;

    // 控件赋值
    [self assignmentWithModule];
}

/** 全部提现 */
- (IBAction)AllWithdrawal
{
    self.withdrawTextField.text = [NSString stringWithFormat:@"%.2lf", [self.amount floatValue]];
}

/** 申请提现 */
- (IBAction)applyDeposit
{

    if (self.realNameTextField.text.length == 0) {
        [CZProgressHUD showProgressHUDWithText:@"请输入真实姓名"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    if (self.accountTextField.text.length == 0) {
        [CZProgressHUD showProgressHUDWithText:@"请输入支付宝账号"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    if (self.withdrawTextField.text.length == 0 ||  [self.withdrawTextField.text floatValue] < [self.maxMoney.text integerValue]) {
        [CZProgressHUD showProgressHUDWithText:[NSString stringWithFormat:@"金额大于%ld元", [self.maxMoney.text integerValue]]];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"realname"] = self.realNameTextField.text;
    param[@"account"] = self.accountTextField.text;
    param[@"amount"] = self.withdrawTextField.text;

    //获取详情数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/withdraw"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            [CZProgressHUD showProgressHUDWithText:@"提现成功"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 去评分
                [self gotoScore];
            });


        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:1.5];

    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

- (void)getNoteData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getWithdrawNote"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.notelabel.text = result[@"withdrawNote"];
            self.maxMoney.text = [NSString stringWithFormat:@"%@元", result[@"minWithdraw"]] ;
        } else {

        }
    } failure:^(NSError *error) {
    }];
}

- (void)getALPayAccount
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getTaobaoAccount"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.realNameTextField.text = result[@"data"][@"realname"];
            self.accountTextField.text = result[@"data"][@"account"];
            if (self.realNameTextField.text.length > 0) {
                self.realNamePlaceHolder.hidden = NO;
            }
            if (self.accountTextField.text.length > 0) {
                self.accountPlaceHolder.hidden = NO;
            }
        } else {

        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 去评分
- (void)gotoScore
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/getScoreStatus"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if (![result[@"data"] isEqual:@(0)]) {
            // 未评价
            UIView *alertView = [[UIView alloc] init];
            alertView.frame = [UIScreen mainScreen].bounds;
            alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [[UIApplication sharedApplication].keyWindow addSubview:alertView];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reclaimerKeyboard:)];
            [alertView addGestureRecognizer:tap];


            CZGotoScoreView *alert = [CZGotoScoreView gotoScoreView];
            alert.center = CGPointMake(SCR_WIDTH / 2.0, SCR_HEIGHT / 2.0);
            alert.layer.cornerRadius = 10;
            alert.layer.masksToBounds = YES;
            [alertView addSubview:alert];


            
        } else {

        }
    } failure:^(NSError *error) {
    }];
}

- (void)reclaimerKeyboard:(UIGestureRecognizer *)tap
{
    NSLog(@"-------");
    [tap.view endEditing:YES];

}


#pragma mark - 控件赋值
- (void)assignmentWithModule
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.topView addGestureRecognizer:tap];
    self.totalPeiceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 30];
    self.totalPeiceLabel.text = [NSString stringWithFormat:@"¥%.2lf", [self.amount floatValue]];
    self.withdrawTextField.delegate = self;
    [self.withdrawTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldBeginNotifi:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEndNotifi:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)textFieldBeginNotifi:(NSNotification *)noti
{
    UITextField *currentTextField = noti.object;
    if (currentTextField == self.realNameTextField) {
        self.realNamePlaceHolder.hidden = YES;
    } else {
        self.accountPlaceHolder.hidden = YES;
    }
}

- (void)textFieldEndNotifi:(NSNotification *)noti
{
    UITextField *currentTextField = noti.object;
    if (currentTextField == self.realNameTextField) {
         if (self.realNameTextField.text.length > 0) return;
        self.realNamePlaceHolder.hidden = NO;
    } else {
        if (self.accountTextField.text.length > 0) return;
        self.accountPlaceHolder.hidden = NO;
    }
}

- (void)hideKeyBoard:(UIGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark -- 代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"---------%@", string);
    NSString *text = [textField.text stringByAppendingString:string];
    NSArray *arr = [text componentsSeparatedByString:@"."];
    if (arr.count > 1) {
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
            return NO;
        } else {
            if ([arr[1] length] > 2) {
                return NO;
            } else {
                return YES;
            }
        }
    } else {
        return YES;
    }
}
- (void)textFieldAction:(UITextField *)textField
{
//    if ([textField.text sub: @"."]) {
//        return NO;
//    } else {
//        return YES;
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
