//
//  CZOneController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/25.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZBaseRecommendController.h"
#import "CZHotTitleModel.h"

typedef NS_ENUM(NSInteger, CZRecommendType) {
    CZRecommendTypeDefault = 0,
    CZRecommendTypeHot,
    CZRecommendTypelight,
    CZRecommendTypeNew,
    CZRecommendTypemost,
    
};

@interface CZOneController : CZBaseRecommendController
/** 大图片URL */
@property (nonatomic, strong) NSString *imageUrl;
/** 标题数组 */
@property (nonatomic, strong) NSArray<CZHotTitleModel *> *titlesArray;

@end
