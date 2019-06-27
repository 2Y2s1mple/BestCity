//
//  CZFreeDetailsubView.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeDetailsubView.h"

@interface CZFreeDetailsubView ()
/** 粉色文字背景 */
@property (nonatomic, weak) IBOutlet UIView *pinkBackView;
/** 粉色文字 */
@property (nonatomic, weak) IBOutlet UILabel *pinkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinkLabelHeight;

/** 倒计时 */
@property (nonatomic, weak) IBOutlet UILabel *countDownLabel;
/** 倒计时背景图 */
@property (nonatomic, weak) IBOutlet UIView *countDownView;
/** 一共多少件 */
@property (nonatomic, weak) IBOutlet UILabel *countDownViewTotalLabel;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间间隔 */
@property (nonatomic, assign) NSInteger interval;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopMargin;

/** 极币数 */
@property (nonatomic, weak) IBOutlet UILabel *jibiLabel;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
//@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;
/** 开抢 */
@property (nonatomic, weak) IBOutlet UILabel *activitiesStartsTimeLabel;

/** 红色条 */
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jibiTopMargin;
@property (nonatomic, weak) IBOutlet UIView *goryBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewWidth; // 红条宽
@property (nonatomic, weak) IBOutlet UILabel *totalLabel; // 一共
@property (nonatomic, weak) IBOutlet UILabel *residueLabel; // 剩余

// 第二个视图
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel1;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel1;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel1;
/** 倒计时 */
@property (nonatomic, weak) IBOutlet UILabel *countDownLabel1;
/** 倒计时停止Block */
@property (nonatomic, copy) void (^countDownBlock)(void);

// 第三个视图
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel2;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel2;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel2;
/** 红色条 */
@property (nonatomic, weak) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewWidth2; // 红条宽
@property (nonatomic, weak) IBOutlet UILabel *totalLabel2; // 一共
@property (nonatomic, weak) IBOutlet UILabel *residueLabel2; // 剩余
@end

@implementation CZFreeDetailsubView
+ (instancetype)freeDetailsubView
{
    CZFreeDetailsubView *view =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.backgroundColor = [UIColor whiteColor];
    [view layoutIfNeeded];
    view.height = CZGetY(view.pinkBackView);
    return view;
}

- (void)setupPorperty
{
    self.pinkLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 12];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.titleLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.jibiLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
    self.priceLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 25];
    self.activitiesStartsTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
}

- (void)setModel:(CZFreeChargeModel *)model
{
    _model = model;
    [self setupPorperty];
    self.pinkLabel.text = model.freeNote;

    if ([model.applyStatus integerValue] == 0) { // 0申请成功未付款
        self.titleLabel1.text = model.name;
        self.priceLabel1.text = [NSString stringWithFormat:@"%.2lf", [model.actualPrice floatValue]];
        NSString *otherPrice = [NSString stringWithFormat:@"¥%.2lf", [model.otherPrice floatValue]];
        self.oldPriceLabel1.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
        // 添加定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupTimer) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantFuture]];

        [self setupCountDown:^(NSDateFormatter *formatter) {
            NSDate *date = [formatter dateFromString:model.dendlineTime];
            return (NSInteger)[date timeIntervalSinceNow];
        }];
        self.countDownLabel1.text = [NSString stringWithFormat:@"距离结束购买时间仅剩：%@", [self setupTimer]];
//        self.backgroundColor = CZGlobalLightGray;
        [self layoutIfNeeded];
        self.height = CZGetY(self.titleLabel1) + 24;
    } else if([model.applyStatus integerValue] == 1) { // 1申请成功已付款,还可以继续购买
        self.titleLabel2.text = model.name;
        self.priceLabel2.text = [NSString stringWithFormat:@"%.2lf", [model.actualPrice floatValue]];
        NSString *otherPrice = [NSString stringWithFormat:@"¥%.2lf", [model.otherPrice floatValue]];
        self.oldPriceLabel2.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];

        // residueLabel  xxx
        // totalLabel goryBackView.width
        [self layoutIfNeeded];
        CGFloat scale = [model.userCount floatValue] / [model.count floatValue];
        self.redViewWidth.constant = scale * (SCR_WIDTH - 44 - 28);
        self.totalLabel2.text = [NSString stringWithFormat:@"共%@件", model.count];
        NSString *residueStr = [NSString stringWithFormat:@"已抢%@件", model.userCount];
        self.residueLabel2.attributedText = [residueStr addAttributeColor:CZREDCOLOR Range:[residueStr rangeOfString:model.userCount]];

        self.height = CZGetY(self.lineView2) + 20;
    }  else { // -1未申请
        self.titleLabel.text = model.name;
        self.jibiLabel.text = [NSString stringWithFormat:@"%@极币", model.point];

        NSString *otherPrice = [NSString stringWithFormat:@"¥%.2lf", [model.actualPrice floatValue]];
        self.priceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];

        self.activitiesStartsTimeLabel.text = [NSString stringWithFormat:@"¥%.2lf", [model.otherPrice floatValue]];

        self.activitiesStartsTimeLabel.text = [self dateFormatterHandle:^{
            return model.activitiesStartTime;
        } formatterStr:@"YYYY-MM-dd HH:mm:ss" toFormattterStr:@"MM月dd日 HH:mm开抢"];

        switch ([model.status integerValue]) { // （0即将开始，1进行中，2已售罄，3已结束）
            case 0:
            {
                // 添加定时器
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupTimer) userInfo:nil repeats:YES];
                [self.timer setFireDate:[NSDate distantFuture]];

                [self setupCountDown:^(NSDateFormatter *formatter) {
                    NSDate *date = [formatter dateFromString:model.activitiesStartTime];
                    return (NSInteger)[date timeIntervalSinceNow];
                }];

                self.countDownLabel.text =[NSString stringWithFormat:@"开抢倒计时：%@", [self setupTimer]];
                self.countDownViewTotalLabel.text = [NSString stringWithFormat:@"共%@件", model.count];
                self.lineView.hidden = YES;
                self.jibiTopMargin.constant = -30;
                break;
            }
            case 1:
            {
                self.countDownView.hidden = YES;
                self.titleLabelTopMargin.constant = -22;
                self.totalLabel.text = [NSString stringWithFormat:@"共%@件", model.count];
                NSString *residueStr = [NSString stringWithFormat:@"已抢%@件", model.userCount];
                self.residueLabel.attributedText = [residueStr addAttributeColor:CZREDCOLOR Range:[residueStr rangeOfString:model.userCount]];
                // residueLabel  xxx
                // totalLabel goryBackView.width
                [self layoutIfNeeded];
                CGFloat scale = [model.userCount floatValue] / [model.count floatValue];

                self.redViewWidth.constant = scale * (SCR_WIDTH - 44 - 28);
                break;
            }
            case 2:
            {
                self.countDownView.hidden = YES;
                self.titleLabelTopMargin.constant = -22;
                self.totalLabel.text = [NSString stringWithFormat:@"共%@件", model.count];
                NSString *residueStr = [NSString stringWithFormat:@"已抢%@件", model.userCount];
                self.residueLabel.attributedText = [residueStr addAttributeColor:CZREDCOLOR Range:[residueStr rangeOfString:model.userCount]];
                // residueLabel  xxx
                // totalLabel goryBackView.width
                [self layoutIfNeeded];
                CGFloat scale = [model.userCount floatValue] / [model.count floatValue];

                self.redViewWidth.constant = scale * (SCR_WIDTH - 44 - 28);
                break;
            }
            default:
                break;
        }
        self.pinkLabel.text = model.freeNote;
        [self layoutIfNeeded];
        self.height = CZGetY(self.pinkBackView);
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
    } else if (_interval < hoursMin && _interval > minutesMin) {
        countDownStr = [NSString stringWithFormat:@"%@分钟%@秒", minutes, seconds];
    } else if (_interval < minutesMin) {
        countDownStr = [NSString stringWithFormat:@"%@秒", seconds];
    } else {
        countDownStr = [NSString stringWithFormat:@"%@天%@小时%@分钟%@秒", day, hours, minutes, seconds];
    }

    if (_interval <= 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.countDownView.hidden = YES;
        self.countDownLabel1.text = @"距离结束购买时间仅剩：0分钟0秒";
        !self.countDownBlock ? : self.countDownBlock();
        return @"0分钟0秒";
    } else {
        self.countDownLabel.text = [NSString stringWithFormat:@"开抢倒计时：%@", countDownStr];
        self.countDownLabel1.text = [NSString stringWithFormat:@"距离结束购买时间仅剩：%@", countDownStr];
    }
    _interval--;
    return countDownStr;

}

#pragma mark - handle
- (NSString *)dateFormatterHandle:(NSString * (^)(void))handler formatterStr:(NSString *)str toFormattterStr:(NSString *)str1
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:str];
    // ----设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *date = [formatter dateFromString:handler()];


    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:str1];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *dateStr = [formatter1 stringFromDate:date];
    return dateStr;
}

#pragma mark - 第二个界面
+ (instancetype)freeDetailsubView1:(void (^)(void))block
{
    CZFreeDetailsubView *view =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][1];
    view.backgroundColor = [UIColor whiteColor];
    [view layoutIfNeeded];
    view.height = CZGetY(view.titleLabel1) + 24;
    view.countDownBlock = block;
    return view;
}

#pragma mark - 第三个界面
+ (instancetype)freeDetailsubView2
{
    CZFreeDetailsubView *view =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    view.backgroundColor = [UIColor whiteColor];
    [view layoutIfNeeded];
    view.height = CZGetY(view.lineView2) + 20;
    return view;
}


@end
