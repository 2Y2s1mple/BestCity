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

@class CZEAttentionItemViewModel;
NS_ASSUME_NONNULL_BEGIN
@protocol CZEAttentionItemViewModelProtocol <NSObject>
@optional
- (void)bindViewModel:(CZEAttentionItemViewModel *)viewModel;
@end

@interface CZEAttentionItemViewModel : NSObject
/** 数据模型 */
@property (nonatomic, strong) CZEAttentionModel *model;
- (instancetype)initWithAttentionModel:(CZEAttentionModel *)model;

/** 判断用户是否有关注 */
@property (nonatomic, assign) BOOL isShowAttention;

/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 删除关注 */
+ (void)deleteAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action;
/** 新增关注 */
+ (void)addAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action;
@end

NS_ASSUME_NONNULL_END
