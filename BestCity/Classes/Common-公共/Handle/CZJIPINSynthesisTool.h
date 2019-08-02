//
//  CZJIPINSynthesisTool.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CZJIPINModuleType){
    CZJIPINModuleHotSale,
    CZJIPINModuleDiscover,
    CZJIPINModuleEvaluation,
    CZJIPINModuleTrail,
    CZJIPINModuleTrailReport,
    CZJIPINModuleBK,
    CZJIPINModuleRelationBK,
    CZJIPINModuleMe,
};

@interface CZJIPINSynthesisTool : NSObject

+ (NSString *)getModuleTypeNumber:(CZJIPINModuleType)type;
+ (CZJIPINModuleType)getModuleType:(NSInteger)typeNumber;
@end

NS_ASSUME_NONNULL_END
