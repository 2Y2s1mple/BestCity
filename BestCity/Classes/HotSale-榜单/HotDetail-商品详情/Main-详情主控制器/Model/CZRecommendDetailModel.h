//
//  CZRecommendDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/8.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZRecommendDetailPointModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZRecommendDetailModel : NSObject
/** 详情的一些参数 */
@property (nonatomic, strong) NSString *goodsId;
/** 轮播图 */
@property (nonatomic, strong) NSArray *imgList;
/** 品质保证 */
@property (nonatomic, strong) NSArray<CZRecommendDetailPointModel *> *qualityList;
/** 售后服务 */
@property (nonatomic, strong) NSArray *serviceList;
/** 产品参数 */
@property (nonatomic, strong) NSArray *parametersList;
/** 商品评测数据 */
@property (nonatomic, strong) NSDictionary *goodsEvalWayEntity;


/** 辅助 */
/** 标题 */
@property (nonatomic, strong) NSString *mainTitle;
/** 券后价 */
@property (nonatomic, strong) NSString *actualPrice;
/** 其他平台 */
@property (nonatomic, strong) NSString *sourcePlatform;
/** 其他平台价格 */
@property (nonatomic, strong) NSString *sourcePlatformPrice;
/** 优惠券 */
@property (nonatomic, strong) NSString *discountCoupon;
@end

NS_ASSUME_NONNULL_END
