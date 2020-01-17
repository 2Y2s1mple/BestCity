//
//  CZFreeChargeHeaderView.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZSubFreeChargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeHeaderView : UIView
/** 数据 */
@property (nonatomic, strong) CZSubFreeChargeModel *model;
+ (instancetype)freeChargeHeaderView;
@end

NS_ASSUME_NONNULL_END
