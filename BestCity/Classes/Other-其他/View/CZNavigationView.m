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
/** 保存Block */
@property (nonatomic, copy) rightBtnBlock rightBlock;
@end

@implementation CZNavigationView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title rightBtnTitle:(NSString *)rightBtnTitle rightBtnAction:(rightBtnBlock)rightBtnAction navigationViewType:(CZNavigationViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"nav-back"] ;
        UIColor *textColor;
        BOOL linehide = NO;;
        switch (type) {
            case CZNavigationViewTypeBlack:
                textColor = [UIColor blackColor];
                break;
            case CZNavigationViewTypeWhite:
                image = [[image imageWithTintColor:[UIColor whiteColor]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                textColor = [UIColor whiteColor];
                linehide = YES;
                break;
                
            default:
                break;
        }
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [leftBtn setImage:image forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(20, 20, 49, self.height - 20);
        leftBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        [leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        titleLabel.text = title;
        titleLabel.textColor = textColor;
        titleLabel.center = CGPointMake(self.width / 2, leftBtn.center.y);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [self addSubview:titleLabel];
        
        if (rightBtnTitle) {
            self.rightBlock = rightBtnAction;
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(SCR_WIDTH - 100, titleLabel.y, 80, 20);
            [rightBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
            [rightBtn setTitleColor:textColor forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
            rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self addSubview:rightBtn];
            [rightBtn addTarget:self action:@selector(didClickedRightBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(leftBtn), SCR_WIDTH, 0.7)];
        line.backgroundColor = CZGlobalLightGray;
        line.hidden = linehide;
        [self addSubview:line];
    }
    return self;
}

- (void)didClickedRightBtn
{
    self.rightBlock();
}

- (void)popAction
{
    
    
    // 隐藏菊花
    [CZProgressHUD hideAfterDelay:0];
    UIView *view = [self superview];
    UIViewController *vc = (UIViewController *)[view nextResponder];
    [vc dismissViewControllerAnimated:YES completion:nil];    
    [vc.navigationController popViewControllerAnimated:YES];
    
    
}

@end
