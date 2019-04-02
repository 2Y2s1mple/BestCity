//
//  CZAffirmPointController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAffirmPointController.h"
#import "CZNavigationView.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"
#import "CZAddressController.h"
#import "CZAddressModel.h"
#import "CZOrderController.h" // 订单

@interface CZAffirmPointController () <CZAddressControllerDelegate>
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *tilteLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bgImage;

@property (nonatomic, weak) IBOutlet UILabel *moneyLabel1;

/** 姓名 */
@property (nonatomic, weak) IBOutlet UILabel *addressNameLabel;
/** 电话号码 */
@property (nonatomic, weak) IBOutlet UILabel *addressNumberLabel;
/** 地址 */
@property (nonatomic, weak)IBOutlet UILabel *addressLabel;
/** 地址数据全部 */
@property (nonatomic, strong) NSDictionary *addressData;
/** 地址ID */
@property (nonatomic, strong) CZAddressModel *model;

/** 添加地址的view */
@property (nonatomic, weak) IBOutlet UIView *addressView;
@property (nonatomic, weak) IBOutlet UIView *changeAddressView;

@end

@implementation CZAffirmPointController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAddress];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"确认订单" rightBtnTitle:nil rightBtnAction:nil navigationViewType:nil];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];

    UITapGestureRecognizer *changeAddressViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAddressView:)];
    
    [self.changeAddressView addGestureRecognizer:changeAddressViewTap];
    
    self.subTitleLabel.text = self.dataSource[@"goodsName"];
    self.subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@极币", self.dataSource[@"exchangePoint"]];
    self.moneyLabel1.text = [NSString stringWithFormat:@"%@极币", self.dataSource[@"exchangePoint"]];
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:self.dataSource[@"img"]]];
}



#pragma mark - 事件
// 跳转到地址界面
- (IBAction)pushAddressView:(UIButton *)sender {
    CZAddressController *vc = [[CZAddressController alloc] init];
    vc.vc = self;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


/** 立即兑换 */
- (IBAction)commit
{
    if (!self.model.addressId) {
        [CZProgressHUD showProgressHUDWithText:@"地址不能为空"];
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"pointGoodsId"] = self.dataSource[@"id"];
    param[@"total"] = @(1);
    param[@"addressId"] = self.model.addressId;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/point/exchange"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            CZOrderController *vc = [[CZOrderController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [CZProgressHUD showProgressHUDWithText:@"商品兑换成功"];
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:3];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//        });
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 代理
// <CZAddressControllerDelegate>
- (void)addressUpdata:(id)addressContext
{
    if (addressContext) {
        self.addressView.hidden = YES;
        self.model = (CZAddressModel *)addressContext;
        /** 姓名 */
        self.addressNameLabel.text = self.model.username;
        /** 电话号码 */
        self.addressNumberLabel.text = self.model.mobile;
        /** 地址 */
        self.addressLabel.text = [self.model.area stringByAppendingFormat:@"%@", self.model.address];
    } else {
        self.addressView.hidden = NO;
    }
}


#pragma mark - 获取数据
// 默认地址
- (void)getAddress
{
    [CZAddressModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"addressId" : @"id"
                 };
    }];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/address/default"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"]  isEqual: @""]) {
                self.addressView.hidden = NO;
                return;
            }
            self.addressView.hidden = YES;
            self.model = [CZAddressModel objectWithKeyValues:result[@"data"]];
            
            /** 姓名 */
            self.addressNameLabel.text = self.model.username;
            /** 电话号码 */
            self.addressNumberLabel.text = self.model.mobile;
            /** 地址 */
            self.addressLabel.text = [self.model.area stringByAppendingFormat:@"%@", self.model.address];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        
    } failure:^(NSError *error) {
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}



@end
