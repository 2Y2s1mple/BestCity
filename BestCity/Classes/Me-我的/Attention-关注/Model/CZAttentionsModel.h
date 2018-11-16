//
//  CZAttentionsModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/10.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZAttentionBtn.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZAttentionsModel : NSObject
/** 用户信息 */
@property (nonatomic, strong) NSDictionary *userShopmember;
/** 记录关注按钮 */
@property (nonatomic, assign) CZAttentionBtnType attentionType;
@end

NS_ASSUME_NONNULL_END
