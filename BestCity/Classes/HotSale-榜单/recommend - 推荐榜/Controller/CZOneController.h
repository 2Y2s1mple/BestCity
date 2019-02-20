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

// 热卖榜
/** 标的数据模型 */
@property (nonatomic, strong) CZHotTitleModel *titleModel;
/** 是否是内部的热卖榜等 */
@property (nonatomic, assign) BOOL isHotList;
/** 各种榜: 1热卖榜，2轻奢榜，3新品榜，4性价比榜 */
@property (nonatomic, assign) CZRecommendType type;
/** 是否是二级列表 */
@property (nonatomic, assign) BOOL isList2;
@end
