//
//  CZNavigationView.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZNavigationView.h"
#import "UIButton+CZExtension.h"


@interface CZNavigationView ()
/** pop按钮 */
@property (nonatomic, strong) UIButton *popBtn;
/** 主标题 */
@property (nonatomic, strong) UILabel *centerTitle;
/** 右边的按钮 */
@property (nonatomic, strong) UIButton *rightBtn;
/** 保存Block */
@property (nonatomic, copy) rightBtnBlock rightBlock;
@end

@implementation CZNavigationView

- (UIButton *)popBtn
{
    if (_popBtn == nil) {
        _popBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_popBtn setImage:[UIImage imageNamed:@"nav-back"] forState:UIControlStateNormal];
        _popBtn.frame = CGRectMake(0, 20, 49, self.height - 20);
        _popBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        _popBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [_popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popBtn;
}

- (UILabel *)centerTitle
{
    if (_centerTitle == nil) {
        _centerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH - 100, 20)];
        _centerTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
        _centerTitle.textColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
        _centerTitle.textColor = UIColorFromRGB(0x0E0402);
        _centerTitle.center = CGPointMake(self.width / 2, self.popBtn.center.y);
        _centerTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _centerTitle;
}

- (void)setRightBtnTextColor:(UIColor *)rightBtnTextColor
{
    _rightBtnTextColor = rightBtnTextColor;
    [self.rightBtn setTitleColor:rightBtnTextColor forState:UIControlStateNormal];

}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title rightBtnTitle:(id)rightBtnTitle rightBtnAction:(rightBtnBlock)rightBtnAction
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.popBtn];
        self.centerTitle.text = title;
        [self addSubview:self.centerTitle];

        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn = rightBtn;
        rightBtn.frame = CGRectMake(SCR_WIDTH - 100, 20, 80, 40);
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:rightBtn];
        rightBtn.centerY = self.popBtn.centerY;
        self.rightBlock = rightBtnAction;

        if ([rightBtnTitle isKindOfClass:[NSString class]]) {
            [rightBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
            [rightBtn setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(didClickedRightBtn) forControlEvents:UIControlEventTouchUpInside];
        } else if ([rightBtnTitle isKindOfClass:[UIImage class]]){
            [rightBtn setImage:(UIImage *)rightBtnTitle forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(didClickedRightBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.7, SCR_WIDTH, 0.7)];
        line.backgroundColor = CZGlobalLightGray;
        [self addSubview:line];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%s", __func__);
}

- (void)didClickedRightBtn
{
    !self.rightBlock ? : self.rightBlock();
}

- (void)popAction
{
    if (self.delegate) {
        [self.delegate popViewController];
    } else {
        // 隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
        for (UIView *next = [self superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                UIViewController *vc = (UIViewController *)nextResponder;
                [vc dismissViewControllerAnimated:YES completion:nil];    
                [vc.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    }
}

@end
