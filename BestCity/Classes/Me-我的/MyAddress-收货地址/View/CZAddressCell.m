//
//  CZAddressCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAddressCell.h"
#import "CZEditAddressController.h"
#import "GXNetTool.h"
#import "CZAddressController.h"


@interface CZAddressCell ()
/** 姓名 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 电话号码 */
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
/** z地址 */
@property (nonatomic, weak)IBOutlet UILabel *addressLabel;
/** 设为默认 */
@property (nonatomic, weak)IBOutlet UIButton *handleBtn;
/** 编辑 */
@property (nonatomic, weak)IBOutlet UIButton *editBtn;
/** 删除 */
@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;
@end


@implementation CZAddressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"addressCell";
    CZAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setAddressModel:(CZAddressModel *)addressModel
{
    _addressModel = addressModel;
    self.nameLabel.text = addressModel.username;
    self.numberLabel.text = addressModel.mobile;
    self.addressLabel.text = [addressModel.area stringByAppendingFormat:@"-%@", addressModel.address];
    self.handleBtn.selected = [addressModel.status integerValue];
}

/* 删除 */
- (IBAction)delete
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认要删除该地址吗？ " message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"addressId"] = self.addressModel.addressId;
        [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/address/delete"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
            if (([result[@"code"] isEqual:@(0)])) {
                [CZProgressHUD showProgressHUDWithText:@"删除成功"];
                [CZProgressHUD hideAfterDelay:1.5];
                [self uploadTableView];
            } 
        } failure:^(NSError *error) {}];
    }]];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    [tabbar presentViewController:alert animated:YES completion:nil];
}

/** 设置为默认 */
- (IBAction)handleBtnAction:(UIButton *)sender
{
    if (self.handleBtn.selected) {
        return;
    }
    sender.enabled = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"addressId"] = self.addressModel.addressId;
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/address/setDefault"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
        }
        sender.enabled = YES;
        [self uploadTableView];
    } failure:^(NSError *error) {
        sender.enabled = YES;
    }];
}

/** push编辑界面 */
- (IBAction)editBtnAction
{
    CZEditAddressController *vc = [[CZEditAddressController alloc] init];
    vc.currnetTitle = @"修改地址";
    vc.addressModel = self.addressModel;
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)uploadTableView
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    CZAddressController *vc = nav.topViewController;
    [vc getDataSource];
}

@end
