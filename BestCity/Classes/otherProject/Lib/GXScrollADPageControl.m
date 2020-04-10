//
//  CZScrollADPageControl.m
//  GXLCodeRepository
//
//  Created by JasonBourne on 2019/12/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "GXScrollADPageControl.h"

@implementation GXScrollADPageControl

#define dotW 7
#define curDotW 15
#define magrin 10
- (void)layoutSubviews
{
    [super layoutSubviews];

    //计算圆点间距
    CGFloat marginX = dotW + magrin;

    // 左右的间距
    CGFloat space = (curDotW - dotW) / 2.0;

    //计算整个pageControll的宽度
    CGFloat newW = self.subviews.count * marginX - magrin + space * 2;
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;


    //遍历subview,设置圆点frame
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *dot = [self.subviews objectAtIndex:i];

        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(space + i * (dotW + magrin), 0, curDotW, dotW)];
            CGPoint center = dot.center;
            dot.center = CGPointMake(center.x - ((curDotW - dotW) / 2.0), self.frame.size.height / 2.0);
        }else {
            [dot setFrame:CGRectMake(space + i * (dotW + magrin), dot.frame.origin.y, dotW, dotW)];
        }
    }

}

//[pageController setValue:[UIImage imageNamed:@"BluePoint.png"] forKeyPath:@"_currentPageImage"];
//[pageController setValue:[UIImage imageNamed:@"black"] forKeyPath:@"_pageImage"];


@end
