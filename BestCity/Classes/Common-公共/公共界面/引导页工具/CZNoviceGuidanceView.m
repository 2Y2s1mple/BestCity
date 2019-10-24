//
//  CZNoviceGuidanceController.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZNoviceGuidanceView.h"
#import "CZNotificationAlertView.h"
#import "CZUpdataManger.h"

@interface CZNoviceGuidanceView ()

@end

@implementation CZNoviceGuidanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self noviceGuidanceView];
    }
    return self;
}

- (void)noviceGuidanceView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide-back-view"]];
    imageView.tag = 10;
    [self addSubview:imageView];
    imageView.frame = self.frame;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"guide-jump"] forState:UIControlStateNormal];
    btn.x = SCR_WIDTH - 50 - 63;
    btn.y = 50;
    [btn sizeToFit];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(guideFinalView:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide-arrow"]];
    arrowImage.tag = 20;
    [arrowImage sizeToFit];
    arrowImage.centerX = self.width / 2.0;
    arrowImage.y = self.height / 2.0 + 30;
    [self addSubview:arrowImage];

    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"guide-next"] forState:UIControlStateNormal];
    [nextBtn sizeToFit];
    nextBtn.centerX = SCR_WIDTH / 2.0;
    nextBtn.y = SCR_HEIGHT - 76 - 47;
    [self addSubview:nextBtn];

    [nextBtn addTarget:self action:@selector(guideNextView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)guideNextView:(UIButton *)sender
{
    UIView *backView = sender.superview;
    UIImageView *imageView1 = [backView viewWithTag:10];
    imageView1.image = [UIImage imageNamed:@"guide-back-view1"];

    sender.hidden = YES;

    UIImageView *imageView2 = [backView viewWithTag:20];
    imageView2.image = [UIImage imageNamed:@"guide-arrow1"];
    [imageView2 sizeToFit];
    imageView2.y += 40;

    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"guide-next1"] forState:UIControlStateNormal];
    [nextBtn sizeToFit];
    nextBtn.centerX = SCR_WIDTH / 2.0;
    nextBtn.y = SCR_HEIGHT / 2.0 - 30;
    [backView addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(guideLastNextView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)guideLastNextView:(UIButton *)sender
{
    UIView *backView = sender.superview;
    [sender setBackgroundImage:[UIImage imageNamed:@"guide-next2"] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(guideFinalView:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView1 = [backView viewWithTag:10];
    imageView1.image = [UIImage imageNamed:@"guide-back-view2"];


    UIImageView *arrowImage = [backView viewWithTag:20];
    arrowImage.image = [UIImage imageNamed:@"guide-arrow2"];
}

- (void)guideFinalView:(UIView *)sender
{
    UIView *backView = sender.superview;

    // 显示版本更新
    [CZUpdataManger ShowUpdataViewWithNetworkService];

    [backView removeFromSuperview];
}


@end
