//
//  CZRecommendListModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/22.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZRecommendListModel : NSObject
/** 商品ID */
@property (nonatomic, strong) NSString *goodsId;
/** 图片 */
@property (nonatomic, strong) NSString *img;
/** 标题 */
@property (nonatomic, strong) NSString *goodsName;
/** 标签 */
@property (nonatomic, strong) NSArray *goodsTagsList;
/** 我们的价格 */
@property (nonatomic, strong) NSString *actualPrice;
/** 商品的平台 */
@property (nonatomic, assign) NSNumber *source; // 1: 京东 2: 淘宝 3: 天猫
/** 其他平台的价格 */
@property (nonatomic, strong) NSString *otherPrice;
/** 访问次数 */
@property (nonatomic, strong) NSString *pv;

/**
 * 辅助
 */
/** cell的编号 */
@property (nonatomic, strong) NSString *indexNumber;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
