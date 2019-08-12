//
//  CZBaseEvaluationController.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZBaseEvaluationController : CZBaseViewController
/** 没有数据图片 */
@property (nonatomic, strong, readonly) CZNoDataView *noDataView;
@end

NS_ASSUME_NONNULL_END
