//
//  CZOrderModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZOrderModel : NSObject
/** id */
@property (nonatomic, strong) NSString *orderId;
/** 标题 */
@property (nonatomic, strong) NSNumber *goodsType;
/** 状态: 0未付款，1为已付款，2为待收货，3为完成 */
@property (nonatomic, strong) NSString *status;
/** 名称 */
@property (nonatomic, strong) NSString *goodsName;
/** 实付 */
@property (nonatomic, strong) NSString *point;
/** 发货时间 */
@property (nonatomic, strong) NSString *sendTime;
/** 下单时间 */
@property (nonatomic, strong) NSString *payTime;
/** 完成时间 */
@property (nonatomic, strong) NSString *finishTime;
/** 数量 */
@property (nonatomic, strong) NSString *total;
/** 图片 */
@property (nonatomic, strong) NSString *img;

/** 名字 */
@property (nonatomic, strong) NSString *username;
/** 电话 */
@property (nonatomic, strong) NSString *mobile;
/** 地址 */
@property (nonatomic, strong) NSString *address;

/** 订单号 */
@property (nonatomic, strong) NSString *ordersn;
/** 快递号 */
@property (nonatomic, strong) NSString *expresssn;
/** 快递公司 */
@property (nonatomic, strong) NSString *expresscom;


/** 辅助 */
@property (nonatomic, assign) CGFloat heightCell;
@end

NS_ASSUME_NONNULL_END
