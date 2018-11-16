//
//  CZEvaluationController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/24.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "WMPageController.h"

@protocol CZEvaluationControllerDelegate <NSObject>
@optional
- (void)reloadChildControlerData;
@end

@interface CZEvaluationController : WMPageController
@property (nonatomic, weak) id<CZEvaluationControllerDelegate> evalutionDelegate;
@end
