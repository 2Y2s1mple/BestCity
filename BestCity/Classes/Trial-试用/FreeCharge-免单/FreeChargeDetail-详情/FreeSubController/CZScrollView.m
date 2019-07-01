//
//  CZScrollView.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZScrollView.h"

@implementation CZScrollView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"%s", __func__);
    return YES;
}


@end
