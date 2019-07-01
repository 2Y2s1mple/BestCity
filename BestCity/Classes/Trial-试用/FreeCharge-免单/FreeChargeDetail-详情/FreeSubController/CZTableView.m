//
//  CZTableView.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/1.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTableView.h"

@implementation CZTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"%s", __func__);
    return YES;
}
@end
