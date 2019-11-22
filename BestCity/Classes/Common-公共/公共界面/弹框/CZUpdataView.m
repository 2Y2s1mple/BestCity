//
//  CZUpdataView.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUpdataView.h"
#import "CZCoinCenterController.h"
#import "UIImageView+WebCache.h"
#import "CZMainHotSaleDetailController.h" // 榜单
#import "CZRecommendDetailController.h" // 商品详情
#import "CZDChoiceDetailController.h" // 测评文章
#import "WMPageController.h"
#import "CZTrialDetailController.h" // 新品试用
#import "CZFreeChargeDetailController.h"
#import "CZSubFreeChargeController.h" // 新品免单


@interface CZUpdataView ()
/** 111111111 */
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
/** 1111111111 */
@property (nonatomic, weak) IBOutlet UILabel *chengeContent;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *pointLabel;

/** 删除按钮 */
@property (nonatomic, weak) IBOutlet UIButton *delectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delectBtnTopConst;

/** 发布成功 */
@property (nonatomic, weak) IBOutlet UILabel *IKnowLabel;
/** <#注释#> */
@property (nonatomic, strong) CZUpdataView *updataView;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIImageView *buyingImage;

/**商品*/
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
/** 到手价 */
@property (nonatomic, weak) IBOutlet UILabel *actualPriceLabel;
/** 名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *reminderLabel;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间间隔 */
@property (nonatomic, assign) NSInteger interval;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *hoursLabel;
/** 注释 */
@property (nonatomic, weak) IBOutlet UILabel *minutesLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *secondsLabel;

@end

@implementation CZUpdataView
@synthesize versionMessage = _versionMessage;
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.IKnowLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
}

+ (instancetype)updataViewWithFrame:(CGRect)frame
{
    CZUpdataView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
    view.frame = frame;
    return view;
}

- (UIView *)getView
{
    return self;
}

/** 去App Store11111111111 */
- (IBAction)gotoUpdata
{
    //跳转到App Store
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app//id1450707933?mt=8"]];
}

/** 删除自己 */
- (IBAction)deleteView
{
    [self removeFromSuperview];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)setVersionMessage:(NSDictionary *)versionMessage
{
    _versionMessage = versionMessage;
    self.versionLabel.text = versionMessage[@"versionName"];
    self.chengeContent.text = versionMessage[@"content"];
    if ([versionMessage[@"needUpdate"] integerValue] == 1) {    
        self.delectBtn.hidden = YES;
    }
}

+ (instancetype)newUserRegistrationView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][1] ;
}

- (void)setUserPoint:(NSString *)userPoint
{
    _userPoint = userPoint;
    self.pointLabel.text = userPoint;
}

/** 新用户祖册 */
- (IBAction)newUserRegistrationAction
{
    [self removeFromSuperview];
    NSLog(@"------");
    CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

+ (instancetype)reviewView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][2];
}

+ (instancetype)reminderView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][3];
}

- (void)setTextString:(NSString *)textString
{
    _textString = textString;
    self.titleLabel.text = textString;
}

/** <#注释#> */
- (IBAction)confirmBlockAction
{
    self.confirmBlock();
}

/** 新人专享 */
+ (instancetype)peopleOfNewView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][4];
}

- (IBAction)peopleClicked:(id)sender {
    NSLog(@"0000000000000");
}

/** 抢购 */
+ (instancetype)buyingView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][5];
}

- (IBAction)buyingClicked:(id)sender {
    NSLog(@"0000000000000");
    [self pushToVC:self.paramDic];
    [self removeFromSuperview];
}

- (void)setParamDic:(NSDictionary *)paramDic
{
    _paramDic = paramDic;
    [self.buyingImage sd_setImageWithURL:[NSURL URLWithString:paramDic[@"img"]]];


}

/** 商品 */
+ (instancetype)goodsView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][6];
}

- (void)setGoodsViewParamDic:(NSDictionary *)goodsViewParamDic
{
    _goodsViewParamDic = goodsViewParamDic;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:goodsViewParamDic[@"img"]]];;
    /** 到手价 */
    NSInteger price = [goodsViewParamDic[@"actualPrice"] floatValue] - [goodsViewParamDic[@"freePrice"] floatValue];
    self.actualPriceLabel.text = [NSString stringWithFormat:@"%ld", price];
    /** 名字 */
    self.nameLabel.text = goodsViewParamDic[@"name"];
    // 提示文字
    self.reminderLabel.text = [NSString stringWithFormat:@"全额售价¥%.2lf  到货返现¥%.2lf元", [goodsViewParamDic[@"freePrice"] floatValue], [goodsViewParamDic[@"freePrice"] floatValue]];

    // 添加定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupTimer) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];

    [self setupCountDown:^(NSDateFormatter *formatter) {
        NSDate *date = [formatter dateFromString:goodsViewParamDic[@"dendlineTime"]];
        return (NSInteger)[date timeIntervalSinceNow];
    }];
}

- (IBAction)buyGoodsClicked:(id)sender {
    NSLog(@"00000");
    CZFreeChargeDetailController *vc = [[CZFreeChargeDetailController alloc] init];
    vc.Id = self.goodsViewParamDic[@"id"];
//    vc.fromType = @"1";
//    vc.fromId = self.goodsViewParamDic[@"fromId"];


    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 2;
    UINavigationController *nav = tabbar.selectedViewController;
    [nav pushViewController:vc animated:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    [self removeFromSuperview];
}


- (void)pushToVC:(NSDictionary *)param
{
    //0默认消息，1榜单首页，11榜单详情，12商品详情，2评测主页，21评测文章，23清单文章web，24清单文章json，3新品主页，31新品详情，4免单主页，41免单详情, 5免单
    NSInteger targetType  = [param[@"targetType"] integerValue];
    NSString *targetId = param[@"targetId"];
    NSString *targetTitle = param[@"targetTitle"];

    switch (targetType) {
        case 11:
        {
            CZMainHotSaleDetailController *vc = [[CZMainHotSaleDetailController alloc] init];
            vc.ID = targetId;
            vc.titleText = [NSString stringWithFormat:@"%@榜单", targetTitle];
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 12:
        {
            CZRecommendDetailController *vc = [[CZRecommendDetailController alloc] init];
            vc.goodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 1;
            break;
        }
        case 21:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleEvaluation;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 23:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleQingDan;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 24:
        {
            CZDChoiceDetailController *vc = [[CZDChoiceDetailController alloc] init];
            vc.detailType = CZJIPINModuleQingDan;
            vc.findgoodsId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            WMPageController *hotVc = (WMPageController *)nav.topViewController;
            hotVc.selectIndex = 0;
            break;
        }
        case 31:
        {
            CZTrialDetailController *vc = [[CZTrialDetailController alloc] init];
            vc.trialId = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            WMPageController *hotVc = (WMPageController *)nav.topViewController;
            hotVc.selectIndex = 1;
            break;
        }
        case 5:
        {
            // 记录新人邀请点击
            didClickedNewPeople = YES;
            if ([JPTOKEN length] <= 0) {
                CZLoginController *vc = [CZLoginController shareLoginController];
                UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
                [tabbar presentViewController:vc animated:NO completion:nil];
                return;
            }

            CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
            break;
        }
        case 41:
        {
            CZFreeChargeDetailController *vc = [[CZFreeChargeDetailController alloc] init];
            vc.Id = targetId;
            UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabbar.selectedIndex = 2;
            UINavigationController *nav = tabbar.selectedViewController;
            [nav pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}

- (void)setupCountDown:(NSInteger (^)(NSDateFormatter *))block
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    // ----设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    self.interval = block(formatter);
    [self.timer setFireDate:[NSDate distantPast]];
}

- (NSString *)setupTimer
{
    // 秒
    NSString *seconds = [NSString stringWithFormat:@"%.2ld", (_interval % 60)];

    // 分
    NSString *minutes = [NSString stringWithFormat:@"%.2ld", (_interval / 60 % 60)];

    // 时

    NSString *hours = [NSString stringWithFormat:@"%.2ld", (_interval / 60 / 60 % 24)];

    // 天
    NSString *day = [NSString stringWithFormat:@"%.2ld", (_interval / 60 / 60 / 24)];

    NSInteger dayMin = 60 * 60 * 24;
    NSInteger hoursMin = 60 * 60;
    NSInteger minutesMin = 60;

    NSString *countDownStr;
    if (_interval < dayMin && _interval > hoursMin) {
        countDownStr = [NSString stringWithFormat:@"%@小时%@分钟%@秒", hours, minutes, seconds];
        self.hoursLabel.text = hours;
        self.minutesLabel.text = minutes;
        self.secondsLabel.text = seconds;
    } else if (_interval < hoursMin && _interval > minutesMin) {
        countDownStr = [NSString stringWithFormat:@"%@分钟%@秒", minutes, seconds];
        self.hoursLabel.text = @"00";
        self.minutesLabel.text = minutes;
        self.secondsLabel.text = seconds;
    } else if (_interval < minutesMin) {
        countDownStr = [NSString stringWithFormat:@"%@秒", seconds];
        self.hoursLabel.text = @"00";
        self.minutesLabel.text = @"00";
        self.secondsLabel.text = seconds;
    } else {
        countDownStr = [NSString stringWithFormat:@"%@天%@小时%@分钟%@秒", day, hours, minutes, seconds];
        NSInteger currentHours = [hours integerValue] + [day integerValue] * 24;
        self.hoursLabel.text = [NSString stringWithFormat:@"%ld", (long)currentHours];
        self.minutesLabel.text = minutes;
        self.secondsLabel.text = seconds;
    }

    if (_interval <= 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.hoursLabel.text = @"00";
        self.minutesLabel.text = @"00";
        self.secondsLabel.text = @"00";
    }
    _interval--;
    return countDownStr;

}






@end
