//
//  CZUserEvaluationView.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZUserEvaluationViewDelegate <NSObject>
@optional
- (void)userEvaluationActionInView:(UIView *)view;

@end

@interface CZUserEvaluationView : UIView
/** <#注释#> */
@property (nonatomic, strong) id<CZUserEvaluationViewDelegate> delegate;

- (CGFloat)userEvaluationContentWithSuperView:(UIView *)view originY:(CGFloat)originY;
@end
