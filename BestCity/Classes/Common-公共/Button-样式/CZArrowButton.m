//
//  CZArrowButton.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZArrowButton.h"

@implementation CZArrowButton
- (void)setup
{

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
    // 调整文字
    [self.titleLabel sizeToFit];
    // 调整图片
    self.titleLabel.x -= self.imageView.width;
    self.imageView.x = CZGetX(self.titleLabel)+ 4;
}

@end
