//
//  CZEditAddressController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEditAddressController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "MOFSPickerManager.h"

@interface CZEditAddressController ()<UITextFieldDelegate>
/** 姓名 */
@property (nonatomic, weak) IBOutlet UITextField *nameLabel;
/** 电话号码 */
@property (nonatomic, weak) IBOutlet UITextField *numberLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UITextField *addrLabel;
/** 地址 */
@property (nonatomic, weak)IBOutlet UITextField *addressLabel;
/** 详细地址 */
@property (nonatomic, weak) IBOutlet UITextField *contentAddressLabel;
@end

@implementation CZEditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.currnetTitle rightBtnTitle:@"保存" rightBtnAction:^{
        if ([self.currnetTitle  isEqual:@"修改地址"]) {
            [self changeCommit];
        } else {        
            [self commit];
        }
    } navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    self.nameLabel.text = self.addressModel.username;
    self.numberLabel.text = self.addressModel.mobile;
    self.addrLabel.text = self.addressModel.area;
    self.contentAddressLabel.text = self.addressModel.address;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)commit
{
    if (![self textFieldControl]) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"username"] = self.nameLabel.text;
    param[@"mobile"] = self.numberLabel.text;
    param[@"area"] = self.addrLabel.text;
    param[@"address"] = self.contentAddressLabel.text;
    
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/address/add"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
            [CZProgressHUD showProgressHUDWithText:@"保存地址成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"保存地址失败"];
        }
        [CZProgressHUD hideAfterDelay:1.5];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)changeCommit
{
    if (![self textFieldControl]) {
        return;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"addressId"] = self.addressModel.addressId;
    param[@"username"] = self.nameLabel.text;
    param[@"mobile"] = self.numberLabel.text;
    param[@"area"] = self.addrLabel.text;
    param[@"address"] = self.contentAddressLabel.text;
    
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/address/update"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
            [CZProgressHUD showProgressHUDWithText:@"保存地址成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"保存地址失败"];
        }
        [CZProgressHUD hideAfterDelay:1.5];
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)pickerView
{
//    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultZipcode:@"450000-450900-450921" title:@"选择地址" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
//        self.addrLabel.text = address;
//        NSLog(@"%@", zipcode);
//
//    } cancelBlock:^{
//
//    }];
}

#pragma mark - 非点击事件
- (BOOL)textFieldControl
{
    if (self.nameLabel.text.length == 0) {
        [CZProgressHUD showProgressHUDWithText:@"请输入收件人名称"];
        [CZProgressHUD hideAfterDelay:1.5];
        return NO;
    } else if (self.numberLabel.text.length != 11) {
        [CZProgressHUD showProgressHUDWithText:@"请正确输入收件人手机号"];
        [CZProgressHUD hideAfterDelay:1.5];
        return NO;
    } else if (self.contentAddressLabel.text.length == 0) {
        [CZProgressHUD showProgressHUDWithText:@"请输入详细地址"];
        [CZProgressHUD hideAfterDelay:1.5];
        return NO;
    } else if (self.addrLabel.text.length == 0) {
        [CZProgressHUD showProgressHUDWithText:@"请输入地区"];
        [CZProgressHUD hideAfterDelay:1.5];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -- end

#pragma mark -- 代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"---------%@", string);
    if ([string  isEqual: @" "]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.addrLabel) {
        [self.view endEditing:YES];
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultZipcode:@"450000-450900-450921" title:@"选择地址" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
            self.addrLabel.text = address;
            NSLog(@"%@", zipcode);
        } cancelBlock:^{}];
        return NO;
    } else {
        return YES;
    }
}

@end
