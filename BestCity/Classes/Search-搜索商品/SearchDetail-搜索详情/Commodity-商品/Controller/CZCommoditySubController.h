//
//  CZCommoditySubController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZCommodityModel.h"
#import "CZCommodityDetailModel.h"
#import "CZCouponsModel.h"

@interface CZCommoditySubController : UIViewController
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 商品数据 */
@property (nonatomic, strong) CZCommodityModel *detailData;
/** 商品详情数据 */
@property (nonatomic, strong) CZCommodityDetailModel *commodityDetailData;
/** 优惠券信息 */
@property (nonatomic, strong) CZCouponsModel *couponData;

/** 极品城返现 */
@property (nonatomic, strong) NSString *fee;

@end
