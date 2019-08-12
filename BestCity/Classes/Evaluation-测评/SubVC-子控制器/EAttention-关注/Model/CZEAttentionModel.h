//
//  CZEAttentionModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CZEAttentionUserModel;
NS_ASSUME_NONNULL_BEGIN

@interface CZEAttentionModel : NSObject
/** 类型: 1文章 2推荐关注*/
@property (nonatomic, strong) NSString *type;
/** 推荐文章 */
@property (nonatomic, strong) NSDictionary *article;
/** 推荐的关注 */
@property (nonatomic, strong) NSArray <CZEAttentionUserModel *> *userList;
@end

NS_ASSUME_NONNULL_END
