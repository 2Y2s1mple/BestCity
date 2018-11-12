//
//  CZAllCriticalModel.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAllCriticalModel.h"

@implementation CZAllCriticalModel
+ (instancetype)allCriticalModelWithDic:(NSDictionary *)dic
{
    CZAllCriticalModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
