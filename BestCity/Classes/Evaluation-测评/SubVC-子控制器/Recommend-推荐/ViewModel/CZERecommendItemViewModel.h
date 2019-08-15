//
//  CZERecommendItemViewModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZERecommendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZERecommendItemViewModel : NSObject
/** 数据 */
@property (nonatomic, strong) CZERecommendModel *model;
- (instancetype)initWithModel:(CZERecommendModel *)model;
/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
