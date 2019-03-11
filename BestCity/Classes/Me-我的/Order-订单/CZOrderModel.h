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
/** 状态: 0未付款，1为已付款，2为待收货，3为完成 */
@property (nonatomic, strong) NSString *status;
/** 名称 */
@property (nonatomic, strong) NSString *goodsName;
/** 实付 */
@property (nonatomic, strong) NSString *point;
/** 发货时间 */
@property (nonatomic, strong) NSString *sendTime;
/** 数量 */
@property (nonatomic, strong) NSString *total;
/** 图片 */
@property (nonatomic, strong) NSString *img;

/** 辅助 */
@property (nonatomic, assign) CGFloat heightCell;
@end

NS_ASSUME_NONNULL_END
