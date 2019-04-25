//
//  CZOrderDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZOrderDetailController.h"
#import "CZNavigationView.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"


@interface CZOrderDetailController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topRadY;
/** 姓名 */
@property (nonatomic, weak) IBOutlet UILabel *addressNameLabel;
/** 电话号码 */
@property (nonatomic, weak) IBOutlet UILabel *addressNumberLabel;
/** 地址 */
@property (nonatomic, weak)IBOutlet UILabel *addressLabel;
/** 状态 */
@property (nonatomic, weak) IBOutlet UILabel *statuslabel;
/** 购买按钮 */
@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, weak) IBOutlet UILabel *tilteLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bgImage;

/** 最下面view */
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@end

static CGFloat const likeAndShareHeight = 49;

@implementation CZOrderDetailController
#pragma mark - 视图
- (UIButton *)buyBtn
{
    if (_buyBtn == nil) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [_buyBtn setBackgroundColor:CZREDCOLOR];
        [_buyBtn addTarget:self action:@selector(affirmWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.x = 0;
        _buyBtn.y = SCR_HEIGHT - likeAndShareHeight - (IsiPhoneX ? 34 : 0);
        _buyBtn.width = SCR_WIDTH;
        _buyBtn.height = likeAndShareHeight;
    }
    return _buyBtn;
}

// 最下面的视图的单元
- (void)setupBottomView:(NSDictionary *)param frameY:(CGFloat)Y
{
    UIView *containerView = [[UIView alloc] init];
    containerView.x = 14;
    containerView.y = Y;
    containerView.width = SCR_WIDTH - 28;
    containerView.height = 25;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = param[@"title"];
    titleLabel.height = containerView.height;
    titleLabel.width = 55;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
    titleLabel.textColor = CZGlobalGray;
    [containerView addSubview:titleLabel];

    UILabel *label1 = [[UILabel alloc] init];
    label1.text = param[@"title1"];
    [label1 sizeToFit];
    label1.x = CZGetX(titleLabel) + 14;
    label1.height = containerView.height;
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];

    label1.textColor = [UIColor blackColor];
    [containerView addSubview:label1];

    if ([param[@"title"]  isEqual: @"快递号"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.x = CZGetX(label1) + 20;
        btn.width = 45;
        btn.height = 25;
        [btn setTitle:@"复制" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = CZGlobalGray.CGColor;
        [containerView addSubview:btn];
        [btn addTarget:self action:@selector(generalPaste) forControlEvents:UIControlEventTouchUpInside];
    }


    [self.bottomView addSubview:containerView];
}

#pragma mark -- end

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"订单详情" rightBtnTitle:nil rightBtnAction:nil navigationViewType:nil];
    [self.view addSubview:navigationView];
    self.topRadY.constant = CZGetY(navigationView);
    
    // 赋值
    [self assignment];

    // 按钮
    [self.view addSubview:self.buyBtn];
}
#pragma mark -- end


#pragma mark - 事件
/** 复制到剪切板 */
- (void)generalPaste
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = self.model.expresssn;
    [CZProgressHUD showProgressHUDWithText:@"复制成功"];
    [CZProgressHUD hideAfterDelay:1.5];
}

// 给控件赋值
- (void)assignment
{
    self.addressNameLabel.text = self.model.username;
    self.addressNumberLabel.text = self.model.mobile;
    self.addressLabel.text = self.model.address;

    if ([self.model.goodsType  isEqual: @(2)]) {
        self.tilteLabel.text = @"极币商城";
    } else {
        self.tilteLabel.text = @"免费试用商品";
    }
    self.subTitleLabel.text = self.model.goodsName;
    self.subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@极币", self.model.point];
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:self.model.img]];

    switch ([self.model.status integerValue]) {
        case 1:
        {
            self.statuslabel.text = @"待发货";
            NSArray *arr = @[
                             @{
                                 @"title" : @"订单号",
                                 @"title1" : self.model.ordersn
                                 },
                             @{
                                 @"title" : @"支付方式",
                                 @"title1" : @"线上支付"
                                 },
                             @{
                                 @"title" : @"下单时间",
                                 @"title1" : self.model.payTime
                                 }
                             ];
            for (int i = 0; i < arr.count; i++) {
                [self setupBottomView:arr[i] frameY:(25 * i) + 20];
            }
            break;
        }
        case 2:
        {
            self.statuslabel.text = @"待收货";
            NSArray *arr = @[
                             @{
                                 @"title" : @"订单号",
                                 @"title1" : self.model.ordersn
                                 },
                             @{
                                 @"title" : @"快递号",
                                 @"title1" : self.model.expresssn
                                 },
                             @{
                                 @"title" : @"快递公司",
                                 @"title1" : self.model.expresscom
                                 },
                             @{
                                 @"title" : @"支付方式",
                                 @"title1" : @"线上支付"
                                 },
                             @{
                                 @"title" : @"下单时间",
                                 @"title1" : self.model.payTime
                                 },
                             @{
                                 @"title" : @"发件时间",
                                 @"title1" : (self.model.sendTime == nil) ? @"2016" :  self.model.sendTime
                                 }
                             ];
            for (int i = 0; i < arr.count; i++) {
                [self setupBottomView:arr[i] frameY:(25 * i) + 20];
            }
            break;
        }
        case 3:
        {
            self.statuslabel.text = @"已完成";
            [self.buyBtn setTitle:@"已收货" forState:UIControlStateNormal];
            [self.buyBtn setBackgroundColor:CZGlobalGray];
            self.buyBtn.enabled = NO;
            NSArray *arr = @[
                             @{
                                 @"title" : @"订单号",
                                 @"title1" : self.model.ordersn
                                 },
                             @{
                                 @"title" : @"快递号",
                                 @"title1" : (self.model.expresssn == nil) ? @"" : self.model.expresssn
                                 },
                             @{
                                 @"title" : @"快递公司",
                                 @"title1" : self.model.expresscom
                                 },
                             @{
                                 @"title" : @"支付方式",
                                 @"title1" : @"线上支付"
                                 },
                             @{
                                 @"title" : @"下单时间",
                                 @"title1" : self.model.payTime
                                 },
                             @{
                                 @"title" : @"发件时间",
                                 @"title1" : (self.model.sendTime == nil) ? @"昨天" :  self.model.sendTime
                                 },
                             @{
                                 @"title" : @"收件时间",
                                 @"title1" : (self.model.finishTime == nil) ? @"今天去哪" :  self.model.finishTime
                                 }
                             ];
            for (int i = 0; i < arr.count; i++) {
                [self setupBottomView:arr[i] frameY:(25 * i) + 20];
            }
            break;
        }
        default:
            break;
    }
}

// 确认收货
- (void)affirmWithBtn:(UIButton *)sender
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.model.orderId;
    //获取数据
    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/order/confirm"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if (([result[@"code"] isEqual:@(0)])) {
            if ([result[@"msg"]  isEqual: @"success"]) {
                [CZProgressHUD showProgressHUDWithText:@"收货成功"];
                [CZProgressHUD hideAfterDelay:1.5];

                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {

    }];
}
#pragma mark -- end

@end
