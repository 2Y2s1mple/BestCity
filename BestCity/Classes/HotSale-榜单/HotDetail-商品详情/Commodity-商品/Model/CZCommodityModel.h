//
//  CZCommodityModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZCommodityModel : NSObject
/** 大图片数组 */
@property (nonatomic, strong) NSArray *imgList;
/** 我们的名字 */
@property (nonatomic, strong) NSString *goodsName;
/** 券后价 */
@property (nonatomic, strong) NSString *actualPrice;
/** 其他平台 */
@property (nonatomic, strong) NSNumber *source;
/** 其他平台价格 */
@property (nonatomic, strong) NSString *otherPrice;
/** 推荐理由 */
@property (nonatomic, strong) NSString *recommendReason;
/** 综合评分 */
@property (nonatomic, strong) NSArray *scoreOptionsList;
/** 综合评分分数 */
@property (nonatomic, strong) NSString *score;


@end

NS_ASSUME_NONNULL_END
