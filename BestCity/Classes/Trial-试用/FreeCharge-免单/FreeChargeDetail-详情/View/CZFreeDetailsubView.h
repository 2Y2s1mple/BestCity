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
+ (instancetype)freeDetailsubView1:(void (^)(void))block;
+ (instancetype)freeDetailsubView2;
@end

NS_ASSUME_NONNULL_END
