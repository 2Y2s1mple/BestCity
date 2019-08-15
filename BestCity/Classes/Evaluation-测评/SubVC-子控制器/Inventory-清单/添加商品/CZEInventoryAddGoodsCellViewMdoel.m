//
//  CZEInventoryAddGoodsCellViewMdoel.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEInventoryAddGoodsCellViewMdoel.h"

@implementation CZEInventoryAddGoodsCellViewMdoel
- (instancetype)initWithviewModel:(NSDictionary *)dataDic
{
    self = [super init];
    if (self) {
        self.dataDic = dataDic;
    }
    return self;
}

@end
