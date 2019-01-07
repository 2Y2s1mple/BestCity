//
//  CZTestDetailModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTestDetailModel : NSObject
/** 用户信息 */
@property (nonatomic, strong) NSDictionary *user;
/** 创建时间 */
@property (nonatomic, strong) NSString *createTime;
/** 内容HTML */
@property (nonatomic, strong) NSString *content;
@end

NS_ASSUME_NONNULL_END
