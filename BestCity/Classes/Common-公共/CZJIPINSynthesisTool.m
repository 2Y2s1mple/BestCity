//
//  CZJIPINSynthesisTool.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZJIPINSynthesisTool.h"

@implementation CZJIPINSynthesisTool
+ (NSString *)getModuleTypeNumber:(CZJIPINModuleType)type
{
     /** 1商品，2评测, 3发现，4试用 */
    NSString *number;
    switch (type) {
        case CZJIPINModuleHotSale: //商品 
            number = @"1";
            break;
        case CZJIPINModuleDiscover: //发现
            number = @"3";
            break;
        case CZJIPINModuleEvaluation: //评测
            number = @"2";
            break;
        case CZJIPINModuleTrail: //试用报告  
            number = @"4";
            break;
        case CZJIPINModuleTrailReport: //试用报告 
            number = @"5";
            break;
        default:
            number = @"";
            break;
    }
    return number;
}
@end
