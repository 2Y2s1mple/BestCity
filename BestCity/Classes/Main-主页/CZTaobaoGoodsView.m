//
//  CZTaobaoGoodsView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTaobaoGoodsView.h"
#import "Masonry.h"

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
/** 极品城补贴 */
@property (nonatomic, weak) IBOutlet UIView *feeView;
/** 补贴数 */
@property (nonatomic, weak) IBOutlet UILabel *feeLabel;
/** 评分view */
@property (weak, nonatomic) IBOutlet UIView *pointView;
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

    if ([model[@"fee"] floatValue] > 0) { // 有极品城补贴
        self.feeLabel.text = [NSString stringWithFormat:@"¥%.2f", [model[@"fee"] floatValue]];
        self.feeView.hidden = NO;
    } else { // 无极品城补贴
        self.feeView.hidden = YES;
        self.titleLabelTop.constant = - 30;
        [self layoutIfNeeded];
    }

    self.titleName.text = model[@"otherName"];

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
        // 无券无补贴
        if ([model[@"couponPrice"] floatValue] > 0) {
            self.titleLabelTop.constant = - 30;
        }
    }
    [self layoutIfNeeded];
    self.commodityH = CGRectGetMaxY(self.pointView.frame);
}

- (IBAction)feeRule:(UIButton *)sender {
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/fee-rule.html"]];
    webVc.titleName = @"极品城购物补贴说明";
    [self.viewController presentViewController:webVc animated:YES completion:nil];
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
