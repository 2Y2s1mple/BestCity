//
//  CZFreeDetailsubView.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
// 模型
#import "CZFreeChargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeDetailsubView : UIView
/** 数据 */
@property (nonatomic, strong) CZFreeChargeModel *model;
+ (instancetype)freeDetailsubView;
@end

NS_ASSUME_NONNULL_END
