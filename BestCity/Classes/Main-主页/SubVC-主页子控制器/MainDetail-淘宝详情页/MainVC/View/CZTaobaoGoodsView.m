//
//  CZTaobaoGoodsView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTaobaoGoodsView.h"
#import "Masonry.h"
#import "GXNetTool.h"
#import "CZOpenAlibcTrade.h"

@interface CZTaobaoGoodsView ()

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTop;


/** 券后价 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/**  其他平台价格 */
@property (nonatomic, weak) IBOutlet UILabel *otherPrice;
/** 优惠券 */
@property (nonatomic, weak) IBOutlet UILabel *couponPrice;
/** 优惠券View */
@property (nonatomic, weak) IBOutlet UIView *couponView;
/** 下边线 */
@property (nonatomic, weak) IBOutlet UIView *lineView;
/** 功能评分图片 */
@property (nonatomic, weak) IBOutlet UIImageView *scoreImage;
/** 功能评分文字 */
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
/** 极品城返现 */
@property (nonatomic, weak) IBOutlet UIView *feeView;
/** 返现数 */
@property (nonatomic, weak) IBOutlet UILabel *feeLabel;
/** 评分view */
@property (weak, nonatomic) IBOutlet UIView *pointView;

/** 发货地 */
@property (nonatomic, weak) IBOutlet UILabel *provcity;
@property (nonatomic, weak) IBOutlet UILabel *volume;
@end

@implementation CZTaobaoGoodsView

+ (instancetype)taobaoGoodsView
{
    CZTaobaoGoodsView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return view;
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    NSString *actualPrice = [NSString stringWithFormat:@"到手价 ¥%.2f", [model[@"buyPrice"] floatValue]];
    self.actualPriceLabel.attributedText = [actualPrice addAttributeFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 21]  Range:[actualPrice rangeOfString:[NSString stringWithFormat:@"¥%.2f", [model[@"buyPrice"] floatValue]]]];


    if ([model[@"otherPrice"] floatValue] > 0 && ![model[@"buyPrice"] isEqual:model[@"otherPrice"]]) {
        self.otherPrice.hidden = NO;
        NSString *therPrice = [NSString stringWithFormat:@"淘宝价¥%.2f", [model[@"otherPrice"] floatValue]];
        self.otherPrice.attributedText = [therPrice addStrikethroughWithRange:[therPrice rangeOfString:therPrice]];
    } else {
        self.otherPrice.hidden = YES;
    }

    if ([model[@"fee"] floatValue] > 0) { // 有极品城返现
        self.feeLabel.text = [NSString stringWithFormat:@"¥%.2f", [model[@"fee"] floatValue]];
        self.feeView.hidden = NO;
    } else { // 无极品城返现
        self.feeView.hidden = YES;
        self.titleLabelTop.constant = - 30;
        [self layoutIfNeeded];
    }

    self.titleName.text = model[@"otherName"];

    self.volume.text = [NSString stringWithFormat:@"%@人已买", model[@"volume"]];

    self.provcity.text = model[@"provcity"];

    if ([model[@"couponPrice"] floatValue] > 0) { // 有优惠券
        self.couponView.hidden = NO;
        // 优惠券信息
        self.couponPrice.text = [NSString stringWithFormat:@"%@", model[@"couponPrice"]];
        self.bottomLabel.text = [NSString stringWithFormat:@"%@ - %@", model[@"couponStartTime"], model[@"couponEndTime"]];
    } else { // 无优惠券
        self.titleLabelTop.constant = 15;
        self.couponView.hidden = YES;
        [self.couponView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        // 无券无返现
        if ([model[@"couponPrice"] floatValue] > 0) {
            self.titleLabelTop.constant = - 30;
        }
    }
    [self layoutIfNeeded];
    self.commodityH = CGRectGetMaxY(self.pointView.frame);
    self.height = self.commodityH;
}

- (IBAction)feeRule:(UIButton *)sender {
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/fee-rule.html"]];
    webVc.titleName = @"极品城购物返现说明";
    [self.viewController presentViewController:webVc animated:YES completion:nil];
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (IBAction)ticketBugLink
{
    if ([JPTOKEN length] <= 0)
    {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
        return;
    }
    // 打开淘宝
    [self getGoodsURl];
}


// 获取购买的URL
- (void)getGoodsURl
{
    UITabBarController *tabVc = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabVc.selectedViewController;
    UIViewController *vc = nav.topViewController;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"goodsBuyLink"] = self.model[@"goodsBuyLink"];
    param[@"otherGoodsId"] = self.model[@"otherGoodsId"];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/getGoodsClickUrl"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 打开淘宝
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:result[@"data"] parentController:self];
        } else {

            [CZProgressHUD showProgressHUDWithText:@"链接获取失败"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}



@end
