//
//  CZERecommendItemViewModel.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZERecommendItemViewModel.h"

@implementation CZERecommendItemViewModel
- (instancetype)initWithModel:(CZERecommendModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}
@end
