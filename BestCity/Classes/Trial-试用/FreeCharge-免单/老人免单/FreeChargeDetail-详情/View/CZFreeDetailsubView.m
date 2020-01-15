//
//  CZFreeDetailsubView.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeDetailsubView.h"

@interface CZFreeDetailsubView ()

/** 倒计时背景图 */
@property (nonatomic, weak) IBOutlet UIView *countDownView;
/** 现价 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 原价 */
@property (nonatomic, weak) IBOutlet UILabel *oldPriceLabel;
/** 一共多少件 */
@property (nonatomic, weak) IBOutlet UILabel *countDownViewTotalLabel;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *inviteLabel;

/** 免单提示*/
@property (nonatomic, weak) IBOutlet UILabel *activitiesStartsTimeLabel;
/** 红色条 */
@property (nonatomic, weak) IBOutlet UIView *lineView;
@property (nonatomic, weak) IBOutlet UIView *goryBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewWidth; // 红条宽
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic, weak) IBOutlet UILabel *totalLabel; // 一共
@property (nonatomic, weak) IBOutlet UILabel *residueLabel; // 剩余
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *residueLabelCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewTopMargin;

/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *bottomImageView;
@end

@implementation CZFreeDetailsubView
+ (instancetype)freeDetailsubView
{
    CZFreeDetailsubView *view =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)setupPorperty
{
//    self.activitiesStartsTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
}

- (void)setModel:(CZFreeChargeModel *)model
{
    _model = model;

//    _model.myInviteUserCount = @"10";
//    _model.inviteUserCount = @"10";

    self.priceLabel.text = [NSString stringWithFormat:@"%.2lf", [model.buyPrice floatValue]];
    NSString *otherPrice = [NSString stringWithFormat:@"¥%.2lf", [model.otherPrice floatValue]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
    self.countDownViewTotalLabel.text = [NSString stringWithFormat:@"已抢%@件", _model.count];
    self.titleLabel.text = _model.name;

    if (self.isOldUser) {
        if ([_model.myInviteUserCount integerValue] < [_model.inviteUserCount integerValue]) {
            NSString *textStr = [NSString stringWithFormat:@"已邀请%@位好友,再邀请%ld位新用户即可享¥%@元返现", _model.myInviteUserCount, [_model.inviteUserCount integerValue] - [_model.myInviteUserCount integerValue], _model.freePrice];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
            [attrStr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xE25838), NSFontAttributeName : [UIFont systemFontOfSize:15]} range:[textStr rangeOfString:_model.myInviteUserCount]];
            [attrStr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xE25838), NSFontAttributeName : [UIFont systemFontOfSize:15]} range:[textStr rangeOfString:[NSString stringWithFormat:@"%ld", [_model.inviteUserCount integerValue] - [_model.myInviteUserCount integerValue]]]];
            [attrStr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xE25838), NSFontAttributeName : [UIFont systemFontOfSize:15]} range:[textStr rangeOfString:[NSString stringWithFormat:@"¥%@", _model.freePrice]]];
            self.inviteLabel.attributedText = attrStr;

        } else {
            NSString *textStr = [NSString stringWithFormat:@"恭喜您已获得免单权益，确认收货后享¥%@元返现", _model.freePrice];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
            [attrStr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xE25838), NSFontAttributeName : [UIFont systemFontOfSize:15]} range:[textStr rangeOfString:[NSString stringWithFormat:@"¥%@", _model.freePrice]]];
            self.inviteLabel.attributedText = attrStr;
        }

        CGFloat scale = [_model.myInviteUserCount floatValue] / [_model.inviteUserCount floatValue];
        if (isinf(scale)) {
            scale = 1;
        } else {
            scale = [_model.myInviteUserCount floatValue] / [_model.inviteUserCount floatValue];
        }

        self.redViewWidth.constant = scale * (SCR_WIDTH - 28);
        if (self.redViewWidth.constant > (SCR_WIDTH - 28 - 100)) {
            self.redViewWidth.constant = SCR_WIDTH - 28;
            self.residueLabel.hidden = YES;
        } else if (self.redViewWidth.constant == 0) {
            self.redViewWidth.constant = 15;
            self.residueLabelCenterX.constant = 17;
            self.residueLabel.text = [NSString stringWithFormat:@"已邀%@人", _model.myInviteUserCount];
        } else {
            self.residueLabel.text = [NSString stringWithFormat:@"已邀%@人", _model.myInviteUserCount];
        }
        self.totalLabel.text = [NSString stringWithFormat:@"（%@/%@人）", _model.myInviteUserCount, _model.inviteUserCount];

        NSString *freeStr = [NSString stringWithFormat:@"免单提示：%@!", _model.freeNote];
        self.activitiesStartsTimeLabel.attributedText = [freeStr addAttributeFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 13] Range:NSMakeRange(0, 5)];
        self.bottomImageView.image = [UIImage imageNamed:@"trail-point"];
        [self layoutIfNeeded];
        self.height = CZGetY(self.activitiesStartsTimeLabel) + 10;
    } else {
        self.bottomImageView.image = [UIImage imageNamed:@"trail-point-1"];
        self.lineView.hidden = YES;
        self.inviteLabel.hidden = YES;
        self.adViewTopMargin.constant = - 70;

        NSString *freeStr = [NSString stringWithFormat:@"免单提示：%@!", _model.freeNote];
        self.activitiesStartsTimeLabel.attributedText = [freeStr addAttributeFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 13] Range:NSMakeRange(0, 5)];
        [self layoutIfNeeded];
        self.height = CZGetY(self.activitiesStartsTimeLabel) + 10;
    }



}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 30];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
}



@end
