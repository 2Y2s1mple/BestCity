//
//  CZZoomImageView.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/23.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZZoomImageView.h"

@implementation CZZoomImageView
CGRect oldRect_;
double duration_ = 0.25;
+ (void)showImage:(UIImageView *)imageView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    oldRect_ = [imageView convertRect:imageView.bounds toView:window];

    UIView *backView = [[UIView alloc] init];
    backView.width = SCR_WIDTH;
    backView.height = SCR_HEIGHT;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [window addSubview:backView];

    UIImageView *currentImageView = [[UIImageView alloc] initWithImage:imageView.image];
    currentImageView.frame = oldRect_;
    [backView addSubview:currentImageView];
    currentImageView.tag = 1;

    CGFloat currentH = currentImageView.image.size.height * SCR_WIDTH / currentImageView.image.size.width;



    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    [backView addGestureRecognizer:tap];


    [UIView animateWithDuration:duration_ animations:^{
        currentImageView.frame = CGRectMake(0, 0, SCR_WIDTH, currentH);
        currentImageView.centerY = SCR_HEIGHT / 2.0;
    }];

}

+ (void)hideImage:(UIGestureRecognizer *)tap
{
    UIView *backView = tap.view;
    UIImageView *imageView = [backView viewWithTag:1];

    [UIView animateWithDuration:duration_ animations:^{
        imageView.frame = oldRect_;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

@end
