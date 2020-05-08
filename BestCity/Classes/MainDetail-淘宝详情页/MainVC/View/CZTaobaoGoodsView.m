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


/**  其他平台价格 */
@property (nonatomic, weak) IBOutlet UILabel *otherPrice;

/** 优惠券View */
@property (nonatomic, weak) IBOutlet UIView *couponView;
/** 下边线 */
@property (nonatomic, weak) IBOutlet UIView *lineView;
/** 功能评分图片 */
@property (nonatomic, weak) IBOutlet UIImageView *scoreImage;
/** 功能评分文字 */
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
/** 返现数 */
@property (nonatomic, weak) IBOutlet UILabel *upFeeLabel;
/** 返现数 */
@property (nonatomic, weak) IBOutlet UILabel *feeMoney;
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
    model = [model deleteAllNullValue];
    _model = model;
    
    CGFloat useAllowancePrice = [self.allDetailModel[@"allowanceGoods"][@"useAllowancePrice"] floatValue];
    CGFloat couponPrice = [model[@"couponPrice"] floatValue];

    if (couponPrice > 0) {
        self.label3.text = [NSString stringWithFormat:@"领%.2f元优惠券，津贴%.2f元", couponPrice, useAllowancePrice];
    } else {
        self.label3.text = [NSString stringWithFormat:@"领津贴%.2f元", useAllowancePrice];
    }

    if (useAllowancePrice > 0) {
        NSString *actualPrice = @"¥0.00";
        self.actualPriceLabel.attributedText = [actualPrice addAttributeFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 21]  Range:NSMakeRange(0, actualPrice.length)];
    } else {
        NSString *actualPrice = [NSString stringWithFormat:@"到手价 ¥%.2f", [model[@"buyPrice"] floatValue]];
        self.actualPriceLabel.attributedText = [actualPrice addAttributeFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 21]  Range:[actualPrice rangeOfString:[NSString stringWithFormat:@"¥%.2f", [model[@"buyPrice"] floatValue]]]];
    }

    if ([model[@"otherPrice"] floatValue] > 0 && ![model[@"buyPrice"] isEqual:model[@"otherPrice"]]) {
        self.otherPrice.hidden = NO;
        NSString *therPrice = [NSString stringWithFormat:@"¥%.2f", [model[@"otherPrice"] floatValue]];
        self.otherPrice.attributedText = [therPrice addStrikethroughWithRange:[therPrice rangeOfString:therPrice]];
    } else {
        self.otherPrice.hidden = YES;
    }
    
    if ([model[@"fee"] floatValue] > 0) { // 有极品城返现
        self.feeMoney.text = [NSString stringWithFormat:@"返 ¥%.2f", [model[@"fee"] floatValue]];
        self.feeView.hidden = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feeRule:)];
        self.feeView.userInteractionEnabled = YES;
        [self.feeView addGestureRecognizer:tap];
    } else { // 无极品城返现
        [self.feeMoney superview].hidden = YES;
    }

    self.titleName.text = model[@"otherName"];
    self.volume.text = [NSString stringWithFormat:@"%@人已买", model[@"volume"]];
    self.provcity.text = model[@"provcity"];

    if (useAllowancePrice > 0) {

    } else {
        if ([model[@"couponPrice"] floatValue] > 0) { // 有优惠券
            self.couponView.hidden = NO;
            // 优惠券信息
            self.couponPrice.text = [NSString stringWithFormat:@"%@", model[@"couponPrice"]];
            self.bottomLabel.text = [NSString stringWithFormat:@"%@ - %@", model[@"couponStartTime"], model[@"couponEndTime"]];
        } else { // 无优惠券
            self.couponView.hidden = YES;
            [self.couponView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
        }
    }
    
    // vip条 最高级, 合伙人
    if ([JPUSERINFO[@"level"] integerValue] == 2) {
        self.feeView.hidden = YES;
        self.titleLabelTop.constant = -30;
        [self layoutIfNeeded];
    } else {
        self.titleLabelTop.constant = 15;
        self.upFeeLabel.text = [NSString stringWithFormat:@"¥%.2f", [model[@"upFee"] floatValue]];
    }

    [self layoutIfNeeded];
    self.commodityH = CGRectGetMaxY(self.pointView.frame);
    self.height = self.commodityH;
}

- (void)feeRule:(UITapGestureRecognizer *)sender {
//    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/fee-rule.html"]];
//    webVc.titleName = @"极品城购物返现说明";
//    [self.viewController presentViewController:webVc animated:YES completion:nil];
    [CZFreePushTool push_memberOfCenter];
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
    CGFloat useAllowancePrice = [self.allDetailModel[@"allowanceGoods"][@"useAllowancePrice"] floatValue];
    if (useAllowancePrice > 0) {
        NSString *ID = self.allDetailModel[@"allowanceGoods"][@"id"];
        [CZJIPINSynthesisTool buyBtnActionWithId:ID alertTitle:nil];
    } else {
        if ([JPTOKEN length] <= 0) {
            CZLoginController *vc = [CZLoginController shareLoginController];
            [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
            return;
        }
        // 打开淘宝
        [self getGoodsURl];
    }
}

// 获取购买的URL
- (void)getGoodsURl
{
    [CZJIPINSynthesisTool jipin_buyLinkById:self.model[@"otherGoodsId"] andSource:self.source];
}



@end
