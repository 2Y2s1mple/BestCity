//
//  CZHotSaleDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZCommodityModel.h"
#import "CZCommodityDetailModel.h"
#import "CZTestDetailModel.h"
#import "CZCouponsModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface CZHotSaleDetailModel : NSObject
/** 商品介绍 */
@property (nonatomic, strong) CZCommodityModel *goodsEntity;
/** 购买参数 */
@property (nonatomic, strong) CZCommodityDetailModel *goodsDetailEntity;
/** 开箱测评数据 */
@property (nonatomic, strong) CZTestDetailModel *evaluationEntity;
/** 优惠券信息 */
@property (nonatomic, strong) CZCouponsModel *goodsCouponsEntity;

@end
NS_ASSUME_NONNULL_END
