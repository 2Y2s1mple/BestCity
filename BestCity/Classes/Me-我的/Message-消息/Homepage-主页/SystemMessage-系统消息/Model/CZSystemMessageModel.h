//
//  CZSystemMessageModel.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/20.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZSystemMessageModel : NSObject
/** id */
@property (nonatomic, strong) NSString *messageUserId;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 时间 */
@property (nonatomic, strong) NSString *createTime;
/** 未读标识 */
@property (nonatomic, strong) NSString *status;
@end

NS_ASSUME_NONNULL_END
