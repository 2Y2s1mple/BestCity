//
//  CZJIPINSynthesisTool.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZJIPINSynthesisTool.h"
#import "GXNetTool.h"

@implementation CZJIPINSynthesisTool
#pragma mark - 判断是哪个模块
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
        case CZJIPINModuleQingDan: //相关百科
            number = @"7";
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
    //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
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
        case 41: // 试用报告
            type = CZJIPINModuleTrail;
            break;
        case 5: // 百科
            type = CZJIPINModuleBK;
            break;
        case 6: // 相关百科
            type = CZJIPINModuleRelationBK;
            break;
        case 7: // 清单详情
            type = CZJIPINModuleQingDan;
            break;
        case 71: // 清单详情
            type = CZJIPINModuleQingDan;
            break;
        default:
            type = 0;
            break;
    }
    return type;
}

// 取消关注
+ (void)deleteAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = attentionUserId;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/delete"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            // 关注
            [CZProgressHUD showProgressHUDWithText:@"取关成功"];
            action();
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 新增关注
+ (void)addAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = attentionUserId;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"关注成功"]) {
            [CZProgressHUD showProgressHUDWithText:@"关注成功"];
            action();
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}
@end
