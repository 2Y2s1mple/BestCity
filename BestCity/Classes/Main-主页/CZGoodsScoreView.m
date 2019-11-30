//
//  CZGoodsScoreView.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGoodsScoreView.h"

@implementation CZGoodsScoreView

+ (instancetype)goodsScoreView
{
    CZGoodsScoreView *backView = [[CZGoodsScoreView alloc] init];
    backView.width = SCR_WIDTH;
    backView.height = SCR_HEIGHT;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    return backView;
}

@end
