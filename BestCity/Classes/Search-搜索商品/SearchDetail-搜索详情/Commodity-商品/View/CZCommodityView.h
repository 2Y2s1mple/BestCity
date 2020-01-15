//
//  CZCommodityView.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/26.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZCommodityModel.h"
#import "CZCouponsModel.h"

@interface CZCommodityView : UIView
+ (instancetype)commodityView;
/** 记录xib的尺寸 */
@property (nonatomic, assign) CGFloat commodityH;
/** 数据 */
@property (nonatomic, strong) CZCommodityModel *model;
/** 优惠券信息 */
@property (nonatomic, strong) CZCouponsModel *couponModel;

/** 极品城返现 */
@property (nonatomic, strong) NSString *fee;

@end
