//
//  CZCommodityView.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/26.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCommodityView.h"
#import "CZOpenAlibcTrade.h"
#import "Masonry.h"
#import "GXNetTool.h"
#import "TSLWebViewController.h"

@interface CZCommodityView ()
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
/** 综合评分 */
@property (nonatomic, weak) IBOutlet UILabel *comprehensiveScoreLabel;
/** 评分中第1个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreFirstImageConstraint;
/** 评分中第1个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreFirstName;
/** 评分中第1个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score1;
/** 评分中第2个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreSecondImageConstraint;
/** 评分中第2个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreSecondName;
/** 评分中第2个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score2;
/** 评分中第3个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreThreeImageConstraint;
/** 评分中第3个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreThreeName;
/** 评分中第3个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score3;
/** 评分中第4个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreThirdImageConstraint;
/** 评分中第4个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreThirdName;
/** 评分中第4个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score4;
/** 评分中第5个的长度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreFiveImageConstraint;
/** 评分中第5个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *scoreFiveName;
/** 评分中第5个的文字 */
@property (weak, nonatomic) IBOutlet UILabel *score5;
/** 评分中第5个的View */
@property (nonatomic, weak) IBOutlet UIView *scoreFiveView;
/** 评分功能 */
@property (nonatomic, weak) IBOutlet UILabel *cscoreLabel;
@end

@implementation CZCommodityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleName.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.cscoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    self.feeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 15];
    self.couponPrice.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 33];
}

+ (instancetype)commodityView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setModel:(CZCommodityModel *)model
{
    _model = model;
    NSString *actualPrice = [NSString stringWithFormat:@"到手价 ¥%.2f", [model.buyPrice floatValue]];
    self.actualPriceLabel.attributedText = [actualPrice addAttributeFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 21]  Range:[actualPrice rangeOfString:[NSString stringWithFormat:@"¥%.2f", [model.buyPrice floatValue]]]];

    if (model.otherPrice.length > 0 && ![model.buyPrice isEqual:model.otherPrice]) {
        self.otherPrice.hidden = NO;
        NSString *therPrice = [NSString stringWithFormat:@"%@¥%.2f", [self platfromNameWithNumber:model.source], [model.otherPrice floatValue]];
        self.otherPrice.attributedText = [therPrice addStrikethroughWithRange:[therPrice rangeOfString:therPrice]];
    } else {
        self.otherPrice.hidden = YES;
    }

    if ([self.fee floatValue] > 0) { // 有极品城返现
        self.feeLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.fee floatValue]];
        self.feeView.hidden = NO;
    } else { // 无极品城返现
        self.feeView.hidden = YES;
        self.titleLabelTop.constant = - 30;
        [self layoutIfNeeded];
    }

    self.titleName.text = model.goodsName;

    if (![self.couponModel.dataFlag  isEqual: @(-1)]) { // 有优惠券
        self.couponView.hidden = NO;
        // 优惠券信息
        self.couponPrice.text = [NSString stringWithFormat:@"%@", self.couponModel.couponMoney];
        self.bottomLabel.text = [NSString stringWithFormat:@"%@ - %@", self.couponModel.validStartTime, self.couponModel.validEndTime];
    } else { // 无优惠券
        self.titleLabelTop.constant = 15;
        self.couponView.hidden = YES;
        [self.couponView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
        // 无券无返现
        if ([self.fee floatValue] == 0) {
            self.titleLabelTop.constant = - 30;
        }
        [self layoutIfNeeded];
    }
    
    // 综合评分
    if (model.scoreOptionsList.count >= 4 && ![model.scoreOptionsList[0][@"name"]  isEqual: @""]) {
        self.pointView.hidden = NO;
        self.comprehensiveScoreLabel.text = [NSString stringWithFormat:@"%.1f", [model.score floatValue]];
        NSInteger maxScore = 150;
        CGFloat everScore = maxScore / 10.0;
        
        self.scoreFirstImageConstraint.constant = 150 - [model.scoreOptionsList[0][@"score"] integerValue] * everScore;
        self.scoreFirstName.text = [model.scoreOptionsList[0][@"name"] setupTextRowSpace];
        self.score1.text = [NSString stringWithFormat:@"%.1f", [model.scoreOptionsList[0][@"score"] floatValue]];
        
        self.scoreSecondImageConstraint.constant = 150 - [model.scoreOptionsList[1][@"score"] integerValue] * everScore;
        self.scoreSecondName.text = [model.scoreOptionsList[1][@"name"] setupTextRowSpace];
        self.score2.text = [NSString stringWithFormat:@"%.1f", [model.scoreOptionsList[1][@"score"] floatValue]];
        
        self.scoreThreeImageConstraint.constant = 150 - [model.scoreOptionsList[2][@"score"] integerValue] * everScore;
        self.scoreThreeName.text = [model.scoreOptionsList[2][@"name"] setupTextRowSpace];
        self.score3.text = [NSString stringWithFormat:@"%.1f", [model.scoreOptionsList[2][@"score"] floatValue]];
        
        self.scoreThirdImageConstraint.constant = 150 - [model.scoreOptionsList[3][@"score"] integerValue] * everScore;
        self.scoreThirdName.text = [model.scoreOptionsList[3][@"name"] setupTextRowSpace];
        self.score4.text = [NSString stringWithFormat:@"%.1f", [model.scoreOptionsList[3][@"score"] floatValue]];
        
        if (model.scoreOptionsList.count == 5) {        
            self.scoreFiveImageConstraint.constant = 150 - [model.scoreOptionsList[4][@"score"] integerValue] * everScore;
            self.scoreFiveName.text = [model.scoreOptionsList[4][@"name"] setupTextRowSpace];
            self.score5.text = [NSString stringWithFormat:@"%.1f", [model.scoreOptionsList[4][@"score"] floatValue]];
            [self layoutIfNeeded];//写在这里是有问题的, 不换行还好
            self.commodityH = CGRectGetMaxY(self.pointView.frame);
        } else {
            self.score5.hidden = YES;
            self.scoreFiveName.hidden = YES;
            self.scoreFiveView.hidden = YES;
            [self layoutIfNeeded];//写在这里是有问题的, 不换行还好
            self.commodityH = CGRectGetMaxY(self.pointView.frame) - 30;
        }
    } else {
        self.pointView.hidden = YES;
        self.scoreImage.hidden = YES;
        self.scoreLabel.hidden = YES;
        [self layoutIfNeeded];//写在这里是有问题的, 不换行还好
        self.commodityH = CGRectGetMaxY(self.lineView.frame);
    }
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
    param[@"goodsId"] = self.model.goodsId;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getGoodsBuyLink"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            // 打开淘宝
            [CZOpenAlibcTrade openAlibcTradeWithUrlString:result[@"data"] parentController:vc];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"链接获取失败"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}

- (NSString *)platfromNameWithNumber:(NSNumber *)platformNumber
{
    // 平台
    NSString *status;
    switch ([platformNumber integerValue]) {
        case 0:
            status = @"原价";
            break;
        case 1:
            status = @"京东价";
            break;
        case 2:
            status = @"淘宝价";
            break;
        case 3:
            status = @"天猫价";
            break;
        default:
            status = @"";
            break;
    }
    return status;
}

- (IBAction)feeRule:(UIButton *)sender {
    TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jipincheng.cn/fee-rule.html"]];
    webVc.titleName = @"极品城购物返现说明";
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
