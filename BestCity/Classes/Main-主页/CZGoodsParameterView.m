//
//  CZGoodsParameterView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGoodsParameterView.h"

@implementation CZGoodsParameterView

+ (instancetype)goodsParameterView
{
    CZGoodsParameterView *backView = [[CZGoodsParameterView alloc] init];
    backView.width = SCR_WIDTH;
    backView.height = SCR_HEIGHT;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

    [backView createSubViews];
    return backView;
}

- (void)createSubViews
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.y = 141;
    view.width = self.width;
    view.height = self.height - view.y;
    [self addSubview:view];
}


@end
