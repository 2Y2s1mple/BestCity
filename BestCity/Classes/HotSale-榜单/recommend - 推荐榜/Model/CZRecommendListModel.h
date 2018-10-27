//
//  CZRecommendListModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/22.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CZHotScoreModel;

@interface CZRecommendListModel : NSObject
/** 标题 */
@property (nonatomic, strong) NSString *goodsName;
/** 标签 */
@property (nonatomic, strong) NSArray *goodstypeList;
/** 我们的价格 */
@property (nonatomic, strong) NSString *actualPrice;
/** 省多钱 */
@property (nonatomic, strong) NSString *cutPrice;
/** 商品的平台 */
@property (nonatomic, assign) NSInteger sourceStatus; // 1: 京东 2: 淘宝 3: 天猫
/** 其他平台的价格 */
@property (nonatomic, strong) NSString *otherPrice;
/** 访问次数 */
@property (nonatomic, strong) NSString *visitCount;
/** 推荐理由 */
@property (nonatomic, strong) NSString *recommendReason;
/** 综合评分 */
@property (nonatomic, strong) NSString *goodsGrade;
/** 综合评分名字和分数 */
@property (nonatomic, strong) NSArray<CZHotScoreModel *> *goodsScopeList;
/** cell的编号 */
@property (nonatomic, strong) NSString *indexNumber;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
