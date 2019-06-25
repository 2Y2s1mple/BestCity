//
//  CZFreeChargeCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell.h"
#import "UIImageView+WebCache.h"


@interface CZFreeChargeCell ()
/** 背景视图View */
@property (nonatomic, weak) IBOutlet UIView *bigView;
/** 图片的View */
@property (nonatomic, weak) IBOutlet UIView *backView;
/** 大图片 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** 极币数 */
@property (nonatomic, weak) IBOutlet UILabel *jibiLabel;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;

/** lineView */
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jibiTopMargin;
@property (nonatomic, weak) IBOutlet UIView *goryBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewWidth;

/** 倒计时 */
@property (nonatomic, weak) IBOutlet UILabel *countDownLabel;
/** 倒计时背景图 */
@property (nonatomic, weak) IBOutlet UIView *countDownView;
/** 一共多少件 */
@property (nonatomic, weak) IBOutlet UILabel *countDownViewTotalLabel;

/** 即将开启 */
@property (nonatomic, weak) IBOutlet UIButton *btn;
/** 一共 */
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
/** 剩余 */
@property (nonatomic, weak) IBOutlet UILabel *residueLabel;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 时间间隔 */
@property (nonatomic, assign) NSInteger interval;

/** 蒙版 */
@property (nonatomic, weak) IBOutlet UIImageView *mengbanImageView;
@end

@implementation CZFreeChargeCell
- (void)setModel:(CZFreeChargeModel *)model
{
    _model = model;

    self.mengbanImageView.hidden = YES;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.titleLabel.text = model.name;
    self.jibiLabel.text = [NSString stringWithFormat:@"%@极币", model.point];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2lf", [model.actualPrice floatValue]];
    NSString *otherPrice = [NSString stringWithFormat:@"¥%.2lf", [model.otherPrice floatValue]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];

    // 条
    self.lineView.hidden = NO;
    self.jibiTopMargin.constant = 28;

    // 开启定时器
    self.countDownView.hidden = YES;

    switch ([model.status integerValue]) {// （0即将开始，1进行中，2已结束）
        case 0:
        {
            [self.btn setTitle:@"即将开始" forState:UIControlStateNormal];
            [self.btn setBackgroundColor:[UIColor whiteColor]];
            [self.btn setTitleColor:UIColorFromRGB(0xF76B1C) forState:UIControlStateNormal];
            self.btn.layer.borderColor = UIColorFromRGB(0xF76B1C).CGColor;
            self.lineView.hidden = YES;
            self.jibiTopMargin.constant = -30;
            self.countDownViewTotalLabel.text = [NSString stringWithFormat:@"共%@件", model.count];
            // 开启定时器
            self.countDownView.hidden = NO;
            [self setupCountDown:^(NSDateFormatter *formatter) {
                NSDate *date = [formatter dateFromString:model.activitiesStartTime];
                return (NSInteger)[date timeIntervalSinceNow];
            }];
            self.countDownLabel.text = [self setupTimer];
            break;
        }
        case 1:
        {
            [self.btn setTitle:@"立即抢购" forState:UIControlStateNormal];
            [self.btn setBackgroundColor:UIColorFromRGB(0xE31B3C)];
            [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.btn.layer.borderColor = UIColorFromRGB(0xE31B3C).CGColor;
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
            self.mengbanImageView.hidden = NO;
            [self.btn setTitle:@"已售罄" forState:UIControlStateNormal];
            [self.btn setBackgroundColor:UIColorFromRGB(0xACACAC)];
            [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.btn.layer.borderColor = UIColorFromRGB(0xACACAC).CGColor;
            self.totalLabel.text = [NSString stringWithFormat:@"共%@件", model.count];
            NSString *residueStr = [NSString stringWithFormat:@"已抢%@件", model.userCount];
            self.residueLabel.attributedText = [residueStr addAttributeColor:CZREDCOLOR Range:[residueStr rangeOfString:model.userCount]];
            [self layoutIfNeeded];
            CGFloat scale = [model.userCount floatValue] / [model.count floatValue];
            self.redViewWidth.constant = scale * (SCR_WIDTH - 44 - 28);
            break;
        }
        case 3:
        {
            [self.btn setTitle:@"已结束" forState:UIControlStateNormal];
            [self.btn setBackgroundColor:UIColorFromRGB(0xACACAC)];
            [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.btn.layer.borderColor = UIColorFromRGB(0xACACAC).CGColor;
            self.totalLabel.text = [NSString stringWithFormat:@"共%@件", model.count];
            NSString *residueStr = [NSString stringWithFormat:@"已抢%@件", model.userCount];
            self.residueLabel.attributedText = [residueStr addAttributeColor:CZREDCOLOR Range:[residueStr rangeOfString:model.userCount]];
            [self layoutIfNeeded];
            CGFloat scale = [model.userCount floatValue] / [model.count floatValue];
            self.redViewWidth.constant = scale * (SCR_WIDTH - 44 - 28);
            break;
        }

        default:
            break;
    }


    [self layoutIfNeeded];
    model.cellHeight = CZGetY(self.bigView);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeChargeCell";
    CZFreeChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.totalLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];
    self.residueLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];


    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.jibiLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13];

    // 设置圆角
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    self.bigView.layer.cornerRadius = 5;
    self.bigView.layer.shadowColor = UIColorFromRGB(0x828282).CGColor;
    self.bigView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bigView.layer.shadowOpacity = 1;
    self.bigView.layer.shadowRadius = 5;
    // 添加定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupTimer) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
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

    if (_interval <= 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.countDownView.hidden = YES;
        self.model.status = @"1";
        [self.btn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [self.btn setBackgroundColor:UIColorFromRGB(0xE31B3C)];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn.layer.borderColor = UIColorFromRGB(0xE31B3C).CGColor;
    }
    _interval--;

    NSInteger dayMin = 60 * 60 * 24;
    NSInteger hoursMin = 60 * 60;
    NSInteger minutesMin = 60;

    NSString *countDownStr;
    if (_interval < dayMin && _interval > hoursMin) {
        countDownStr = [NSString stringWithFormat:@"开抢倒计时：%@小时%@分钟%@秒", hours, minutes, seconds];
    } else if (_interval < hoursMin && _interval > minutesMin) {
        countDownStr = [NSString stringWithFormat:@"开抢倒计时：%@分钟%@秒", minutes, seconds];
    } else if (_interval < minutesMin) {
        countDownStr = [NSString stringWithFormat:@"开抢倒计时：%@秒", seconds];
    } else {
        countDownStr = [NSString stringWithFormat:@"开抢倒计时：%@天%@小时%@分钟%@秒", day, hours, minutes, seconds];
    }

    self.countDownLabel.text = countDownStr;
    return countDownStr;

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
