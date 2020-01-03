//
//  CZSubFreeChargeModel.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/2.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZSubFreeChargeModel : NSObject
/** 辅助 */
/** 高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 用它来判断类型 */
@property (nonatomic, strong) NSNumber *typeNumber;

/** 数据 */
@property (nonatomic, strong) NSString *otherGoodsId;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *goodsName;
/** 淘宝价 */
@property (nonatomic, strong) NSString *otherPrice;
@property (nonatomic, assign) NSInteger count;
/** 我的津贴 */
@property (nonatomic, strong) NSNumber *allowance;
/** 官方微信 */
@property (nonatomic, strong) NSString *officialWeChat;
/** 津贴抵扣 */
@property (nonatomic, strong) NSNumber *useAllowancePrice;
/** 优惠券 */
@property (nonatomic, strong) NSNumber *couponPrice;
/** 现价 */
@property (nonatomic, strong) NSNumber *buyPrice;


@end

NS_ASSUME_NONNULL_END
