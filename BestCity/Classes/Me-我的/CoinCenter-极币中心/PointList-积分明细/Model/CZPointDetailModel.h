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
@property (nonatomic, strong) NSString *remark;
/** 时间 */
@property (nonatomic, strong) NSString *createTime;
/** 积分数 */
@property (nonatomic, strong) NSString *point;
@end

NS_ASSUME_NONNULL_END
