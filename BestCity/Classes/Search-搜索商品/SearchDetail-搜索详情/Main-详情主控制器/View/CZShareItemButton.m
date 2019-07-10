//
//  CZShareItemButton.m
//  BestCity
//
//  Created by JasonBourne on 2018/12/5.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZShareItemButton.h"

@implementation CZShareItemButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.x = 5;
    self.imageView.y = 0;
    self.imageView.width = self.width - 10;
    self.imageView.height = self.imageView.width;
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height + 10;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.width;
    
}

@end
