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
    CZJIPINModuleQingDan,
};

@interface CZJIPINSynthesisTool : NSObject

+ (NSString *)getModuleTypeNumber:(CZJIPINModuleType)type;
+ (CZJIPINModuleType)getModuleType:(NSInteger)typeNumber;
/** 删除关注 */
+ (void)deleteAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action;
/** 新增关注 */
+ (void)addAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action;
@end

NS_ASSUME_NONNULL_END
