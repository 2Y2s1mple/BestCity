//
//  GXCategoryPageControl.m
//  GXLCodeRepository
//
//  Created by JsonBourne on 2020/4/26.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "GXCategoryPageControl.h"

@implementation GXCategoryPageControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = (self.width / 2);
    
    //遍历subview,设置圆点frame
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        
        dot.layer.cornerRadius = 0;
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * width, 0, width, self.height)];
            
        }else {
            [dot setFrame:CGRectMake(i * width, 0, width,  self.height)];
        }
    }

}


@end
