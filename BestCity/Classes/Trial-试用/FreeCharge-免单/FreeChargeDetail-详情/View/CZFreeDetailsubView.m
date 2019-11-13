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
/** 一共多少件 */
@property (nonatomic, weak) IBOutlet UILabel *countDownViewTotalLabel;

/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopMargin;

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


    self.height = CZGetY(self.activitiesStartsTimeLabel) + 20;

}



@end
