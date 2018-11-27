//
//  PlanPageControl.m
//  PlanADScrollView
//
//  Created by anan on 2017/10/19.
//  Copyright © 2017年 Plan. All rights reserved.
//

#import "PlanPageControl.h"
@interface PlanPageControl()

@end

@implementation PlanPageControl


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



#define dotW 7
#define magrin 10
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算圆点间距
    CGFloat marginX = dotW + magrin;
    
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1 ) * marginX;
    
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
            [dot setFrame:CGRectMake(i * marginX - 2.5, dot.frame.origin.y, dotW + 5, dotW)];
        }else {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
        }
    }
}


@end
