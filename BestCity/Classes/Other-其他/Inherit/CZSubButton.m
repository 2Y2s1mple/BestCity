//
//  CZSubTitleButton.m
//  BestCity
//
//  Created by JasonBourne on 2019/2/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZSubButton.h"

@implementation CZSubButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:CZGlobalGray forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height + 5;
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.width / 2.0;
}

@end
