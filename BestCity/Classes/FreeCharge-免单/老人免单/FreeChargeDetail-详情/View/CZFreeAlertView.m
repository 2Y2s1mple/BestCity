//
//  CZFreeAlertView.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeAlertView.h"
@interface CZFreeAlertView ()
@property (nonatomic, strong) UIView *backView;
/** 暂不参与 */
@property (nonatomic, weak) IBOutlet UIButton *leftBtn;
/** 右边的参数 */
@property (nonatomic, copy) void (^rightBlock)(CZFreeAlertView *);
@property (nonatomic, copy) void (^leftBlock)(CZFreeAlertView *);
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation CZFreeAlertView

+ (instancetype)freeAlertViewRightBlock:(void (^)(CZFreeAlertView *))rightBlock leftBlock:(void (^)(CZFreeAlertView *))leftBlock
{
    CZFreeAlertView *currentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    currentView.leftBlock = rightBlock;
    currentView.rightBlock = leftBlock;
    return currentView;
}

- (IBAction)leftBtnAction:(UIButton *)sender
{
    !self.leftBlock ? : self.leftBlock(self);
    [self hide];
}

- (IBAction)rightBtnAction:(UIButton *)sender
{
    !self.rightBlock ? : self.rightBlock(self);
    [self hide];
}

- (void)show {
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    [backView addSubview:self];
    _backView = backView;
    self.y = SCR_HEIGHT - 172;
    self.size = CGSizeMake(SCR_WIDTH, 172);
}

- (void)hide {
    [_backView removeFromSuperview];
}

- (void)setPoint:(NSString *)point {
    _point = point;
    self.titleLabel.text = [NSString stringWithFormat:@"确认参加将支付%@极币，不支持退币哦，\n祝您好运！", point];
}

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"蒙版"];
    [image drawInRect:rect];
}

@end
