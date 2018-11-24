//
//  CZSubTitleButton.m
//  BestCity
//
//  Created by JasonBourne on 2018/10/27.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZSubTitleButton.h"
#import "CZHotTitleModel.h"

@implementation CZSubTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self setTitleColor:CZREDCOLOR forState:UIControlStateSelected];
    [self setTitleColor:CZGlobalGray forState:UIControlStateNormal];
}

- (void)setModel:(CZHotSubTilteModel *)model
{
    _model = model;
    [self setTitle:model.categoryname forState:UIControlStateNormal];
    if (model.indexBtn == 0) {
        self.selected = YES;
    }
    
}
@end
