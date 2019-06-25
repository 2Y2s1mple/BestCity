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
@end
@implementation CZFreeAlertView2
+ (instancetype)freeAlertView:(void (^)(CZFreeAlertView2 *))rightBlock
{
    CZFreeAlertView2 *currentView = [[[NSBundle mainBundle] loadNibNamed:@"CZFreeAlertView" owner:nil options:nil] lastObject];
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
    backView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    [backView addSubview:self];
    _backView = backView;
    self.y = SCR_HEIGHT - 248;
    self.size = CGSizeMake(SCR_WIDTH, 248);
}

- (void)hide
{
    [_backView removeFromSuperview];
}

- (void)setPoint:(NSString *)point
{
    _point = point;
    self.topLabel.text = [NSString stringWithFormat:@"现有极币：%@个", JPUSERINFO[@"point"]];;
    self.bottomLabel.text = [NSString stringWithFormat:@"所需极币：%@个", point];
}

@end
