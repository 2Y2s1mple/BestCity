//
//  CZPointDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/12.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZPointDetailModel : NSObject
/** 标题 */
@property (nonatomic, strong) NSString *pay_name;
/** 时间 */
@property (nonatomic, strong) NSString *accountTime;
/** 提现钱数 */
@property (nonatomic, strong) NSString *amount;
@end

NS_ASSUME_NONNULL_END
