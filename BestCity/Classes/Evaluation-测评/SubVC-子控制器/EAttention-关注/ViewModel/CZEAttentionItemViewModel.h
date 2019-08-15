//
//  CZEAttentionItemViewModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
// 模型
#import "CZEAttentionModel.h"
#import "CZEAttentionUserModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface CZEAttentionItemViewModel : NSObject
/** 数据模型 */
@property (nonatomic, strong) CZEAttentionModel *model;
- (instancetype)initWithAttentionModel:(CZEAttentionModel *)model;

/** 判断用户是否有关注 */
@property (nonatomic, assign) BOOL isShowAttention;

/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
