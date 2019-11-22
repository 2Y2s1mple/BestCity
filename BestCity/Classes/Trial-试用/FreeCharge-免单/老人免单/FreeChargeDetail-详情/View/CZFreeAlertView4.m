//
//  CZFreeAlertView4.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeAlertView4.h"

@interface CZFreeAlertView4 ()
@property (nonatomic, strong) UIView *backView;
/** 右边的参数 */
@property (nonatomic, copy) void (^rightBlock)(NSString *);

@property (nonatomic, weak) IBOutlet UITextField *textField;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleText;
@end

@implementation CZFreeAlertView4
+ (instancetype)freeAlertView:(void (^)(NSString *))rightBlock
{
    CZFreeAlertView4 *currentView = [[NSBundle mainBundle] loadNibNamed:@"CZFreeAlertView" owner:nil options:nil][3];
    currentView.rightBlock = rightBlock;
    return currentView;
}

- (IBAction)rightBtnAction:(UIButton *)sender
{
    !self.rightBlock ? : self.rightBlock(_textField.text);
    
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
    self.size = CGSizeMake(315, 233);
    self.centerX = SCR_WIDTH / 2.0;
}

- (void)hide
{
    [self.textField resignFirstResponder];
    [_backView removeFromSuperview];
}

- (void)setParam:(CZFreeChargeModel *)param
{
    _param = param;
    self.titleText.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
}


@end
