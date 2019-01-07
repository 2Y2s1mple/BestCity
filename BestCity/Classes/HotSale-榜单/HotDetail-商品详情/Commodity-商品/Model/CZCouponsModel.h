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
@end

NS_ASSUME_NONNULL_END
