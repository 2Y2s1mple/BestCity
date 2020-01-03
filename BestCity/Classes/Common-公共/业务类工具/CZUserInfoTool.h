//
//  CZUserInfoTool.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/20.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CZUserInfoBlock)(NSDictionary *param);

@interface CZUserInfoTool : NSObject
+ (void)userInfoInformation:(CZUserInfoBlock)block;
+ (void)changeUserInfo:(NSDictionary *)info callbackAction:(CZUserInfoBlock)action;
/** 获取佣金 */
+ (void)userInfoCommssionCallback:(CZUserInfoBlock)action;
@end

