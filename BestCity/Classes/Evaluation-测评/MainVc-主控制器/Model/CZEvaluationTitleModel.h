//
//  CZEvaluationTitleModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/16.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEvaluationTitleModel : NSObject
/** 标题的ID */
@property (nonatomic, strong) NSString *categoryId;
/** 标题的ID */
@property (nonatomic, strong) NSString *categoryName;
/** 图片url */
@property (nonatomic, strong) NSString *img;
@end

NS_ASSUME_NONNULL_END
