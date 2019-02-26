//
//  CZCouponsModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZCouponsModel : NSObject
/** 优惠券钱数 */
@property (nonatomic, strong) NSString *couponMoney;
/** 开始时间 */
@property (nonatomic, strong) NSString *validStartTime;
/** 结束时间 */
@property (nonatomic, strong) NSString *validEndTime;
/** 优惠券链接*/
@property (nonatomic, strong) NSString *couponsUrl;
/** 判断优惠券过期 1:有效 -1:过期 */
@property (nonatomic, strong) NSNumber *dataFlag;
@end

NS_ASSUME_NONNULL_END
