//
//  CZEndLineView.m
//  BestCity
//
//  Created by JasonBourne on 2018/12/3.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZEndLineView.h"

@implementation CZEndLineView

+ (instancetype)endLineView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
