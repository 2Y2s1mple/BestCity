//
//  CZFreeAlertView3.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
// 模型
#import "CZFreeChargeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZFreeAlertView3 : UIView
+ (instancetype)freeAlertView:(void (^)(CZFreeAlertView3 *))rightBlock;
- (void)hide;
- (void)show;
/** <#注释#> */
@property (nonatomic, strong) CZFreeChargeModel *param;
@end

NS_ASSUME_NONNULL_END
