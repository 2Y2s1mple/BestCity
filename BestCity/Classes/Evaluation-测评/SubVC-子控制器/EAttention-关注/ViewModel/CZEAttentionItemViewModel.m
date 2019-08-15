//
//  CZEAttentionItemViewModel.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEAttentionItemViewModel.h"
#import "GXNetTool.h"

@implementation CZEAttentionItemViewModel
- (instancetype)initWithAttentionModel:(CZEAttentionModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

@end
