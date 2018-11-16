//
//  CZEvaluateToolBar.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/12.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZEvaluateToolBar.h"

@interface CZEvaluateToolBar ()


@end

@implementation CZEvaluateToolBar

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (instancetype)evaluateToolBar
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)sandBtnAction:(UIButton *)sender {
    NSLog(@"---sandBtnAction---");
}

@end
