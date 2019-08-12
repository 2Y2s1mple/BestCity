//
//  CZEvaluationViewModel.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEvaluationViewModel.h"

@implementation CZEvaluationViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titlesText = @[@"关注", @"推荐", @"评测", @"清单"];
    }
    return self;
}



@end
