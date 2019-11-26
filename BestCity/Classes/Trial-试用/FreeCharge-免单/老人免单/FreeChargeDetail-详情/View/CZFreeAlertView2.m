//
//  CZFreeAlertView2.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeAlertView2.h"
@interface CZFreeAlertView2 ()
@property (nonatomic, strong) UIView *backView;
/** 右边的参数 */
@property (nonatomic, copy) void (^rightBlock)(CZFreeAlertView2 *);
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleText;
@end
@implementation CZFreeAlertView2
+ (instancetype)freeAlertView:(void (^)(CZFreeAlertView2 *))rightBlock
{
    CZFreeAlertView2 *currentView = [[NSBundle mainBundle] loadNibNamed:@"CZFreeAlertView" owner:nil options:nil][1];
    currentView.rightBlock = rightBlock;
    return currentView;
}

- (IBAction)leftBtnAction:(UIButton *)sender
{
    [self hide];
}

- (IBAction)rightBtnAction:(UIButton *)sender
{
    !self.rightBlock ? : self.rightBlock(self);
    [self hide];
}

- (void)show
{
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    [backView addSubview:self];
    _backView = backView;
    self.y = 165;
    self.size = CGSizeMake(315, 230);
    self.centerX = SCR_WIDTH / 2.0;
}

- (void)hide
{
    [_backView removeFromSuperview]; 
}

- (void)setParam:(CZFreeChargeModel *)param
{
    _param = param;
    self.titleText.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.topLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.topLabel.text = [NSString stringWithFormat:@"￥%@", param.actualPrice];;
    self.bottomLabel.text = [NSString stringWithFormat:@"￥%@", param.freePrice];
}

@end
