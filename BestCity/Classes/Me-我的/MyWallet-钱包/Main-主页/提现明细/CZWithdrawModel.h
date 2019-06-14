//
//  CZWithdrawModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZWithdrawModel : NSObject
/** 时间 */
@property (nonatomic, strong) NSString *createTime;
/** 钱 */
@property (nonatomic, strong) NSString *amount;
/** 状态 */
@property (nonatomic, strong) NSString *status;
/** 理由 */
@property (nonatomic, strong) NSString *failReason;

/** 辅助 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
