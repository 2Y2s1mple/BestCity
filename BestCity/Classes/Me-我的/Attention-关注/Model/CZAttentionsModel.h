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
/** 用户ID */
@property (nonatomic, strong) NSString *userId;
/** 名字 */
@property (nonatomic, strong) NSString *nickname;
/** 头像 */
@property (nonatomic, strong) NSString *avatar;
/** 关注状态 */
@property (nonatomic, strong) NSNumber *status; // status:1互关 0没有互关
/** cell的类型 */
@property (nonatomic, strong) NSString *cellType;
@end

NS_ASSUME_NONNULL_END
