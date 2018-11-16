//
//  CZEvaluateSubController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZRecommendDetailModel.h"

@interface CZEvaluateSubController : UIViewController
/** 详情数据模型 */
@property (nonatomic, strong) CZRecommendDetailModel *model;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
@end
