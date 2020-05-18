//
//  GXZoomImageView.m
//  GXLCodeRepository
//
//  Created by JasonBourne on 2020/3/25.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "GXZoomImageView.h"

@implementation GXZoomImageView

// static改变全局变量为当前文件访问, 防止有其他文件重名!
static CGRect oldRect_;
static double duration_ = 0.25;
+ (void)showZoomImage:(__kindof UIView * _Nonnull)obj
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    // 通过坐标系转换, 返回当前的view的尺寸
    oldRect_ = [obj convertRect:obj.bounds toView:window];

    // 创建父视图
    UIView *backView = [[UIView alloc] init];
    backView.width = SCR_WIDTH;
    backView.height = SCR_HEIGHT;
    [window addSubview:backView];
    
    // 添加隐藏手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    [backView addGestureRecognizer:tap];

    // 拿到图片先放到老位置
    UIImageView *currentImageView = [[UIImageView alloc] init];
    currentImageView.frame = oldRect_;
    [backView addSubview:currentImageView];
    currentImageView.tag = 1;
    currentImageView.image = [self getImageWithObj:obj];


    // 根据屏幕宽, 计算图片的放大高度
    CGFloat currentH = currentImageView.image.size.height * SCR_WIDTH / currentImageView.image.size.width;
    NSLog(@"-------%d", isnan(currentH));
    if (isnan(currentH)) {
        return;
    }

    // 动画跑到中心位置
    [UIView animateWithDuration:duration_ animations:^{
        currentImageView.frame = CGRectMake(0, 0, SCR_WIDTH, currentH);
        currentImageView.centerY = SCR_HEIGHT / 2.0;
    } completion:^(BOOL finished) {
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    }];
}

// 拿到image
+ (UIImage *)getImageWithObj:(__kindof UIView * _Nonnull)obj
{
/**
 注意: 如果设置[btn setImage:], btn.imageView可以拿到图片
      如果设置[btn setBackgroundImage:], btn.imageView拿不到图片, 通过遍历拿到
 */
    if ([obj isKindOfClass:[UIImageView class]]) { // 是imageView
        UIImageView *imageView = (UIImageView *)obj;
        return (UIImage *)imageView.image;
    } else {
        for (int i = 0; i < obj.subviews.count; i++) { // 是button
            UIImageView *imageView = obj.subviews[i];
             NSLog(@"-----%@", imageView);
            if ([imageView isKindOfClass:[UIImageView class]]) {
                return (UIImage *)imageView.image;
            }
        }
        NSLog(@"\n\n\n\n\n\n\n\n 没找到图片");
        return nil;
    }
}

+ (void)hideImage:(UIGestureRecognizer *)tap
{
    UIView *backView = tap.view;
    backView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [backView viewWithTag:1];

    // 动画跑到记录的位置, 隐藏
    [UIView animateWithDuration:duration_ animations:^{
        imageView.frame = oldRect_;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

@end
