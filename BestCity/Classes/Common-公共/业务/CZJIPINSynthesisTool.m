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
     /** 1商品，2评测, 3发现，4试用 5百科 6相关百科*/
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
        case CZJIPINModuleBK: //百科
            number = @"5";
            break;
        case CZJIPINModuleRelationBK: //相关百科
            number = @"6";
            break;
        default:
            number = @"";
            break;
    }
    return number;
}

+ (CZJIPINModuleType)getModuleType:(NSInteger)typeNumber
{
    /** 1商品，2评测, 3发现，4试用 */
    CZJIPINModuleType type;
    switch (typeNumber) {
        case 1: //商品
            type = CZJIPINModuleHotSale;
            break;
        case 3: //发现
            type = CZJIPINModuleDiscover;
            break;
        case 2: // 评测
            type = CZJIPINModuleEvaluation;
            break;
        case 4: // 试用报告
            type = CZJIPINModuleTrail;
            break;
        case 5: // 百科
            type = CZJIPINModuleBK;
            break;
        case 6: // 相关百科
            type = CZJIPINModuleRelationBK;
            break;
        default:
            type = 0;
            break;
    }
    return type;
}
@end
