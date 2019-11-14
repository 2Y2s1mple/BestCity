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
@property (nonatomic, weak) IBOutlet UILabel *totalLabel; // 一共
@property (nonatomic, weak) IBOutlet UILabel *residueLabel; // 剩余

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

    self.priceLabel.text = [NSString stringWithFormat:@"%.2lf", [model.buyPrice floatValue]];
    NSString *otherPrice = [NSString stringWithFormat:@"¥%.2lf", [model.otherPrice floatValue]];
    self.oldPriceLabel.attributedText = [otherPrice addStrikethroughWithRange:[otherPrice rangeOfString:otherPrice]];
    self.countDownViewTotalLabel.text = [NSString stringWithFormat:@"已抢%@件", _model.count];
    self.titleLabel.text = _model.name;

    if ([_model.myInviteUserCount integerValue] < [_model.inviteUserCount integerValue]) {
        self.inviteLabel.text = [NSString stringWithFormat:@"已邀请%@位好友,再邀请%ld位新用户即可享¥%@元补贴", _model.myInviteUserCount, [_model.inviteUserCount integerValue] - [_model.myInviteUserCount integerValue], _model.freePrice];
    } else {

    }


    self.height = CZGetY(self.activitiesStartsTimeLabel) + 20;

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 30];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
}



@end
