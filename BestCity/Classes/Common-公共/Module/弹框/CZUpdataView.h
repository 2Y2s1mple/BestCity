//
//  CZUpdataView.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZUpdataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZUpdataView : UIView <CZUpdataProtocol>
/** 新用户给积分 */
@property (nonatomic, strong) NSString *userPoint;

+ (instancetype)newUserRegistrationView;

/** 审核中 */
+ (instancetype)reviewView;

// 提示
+ (instancetype)reminderView;

/** <#注释#> */
@property (nonatomic, strong) void (^confirmBlock) (void);

/** <#注释#> */
@property (nonatomic, strong) NSString *textString;
@end

NS_ASSUME_NONNULL_END
