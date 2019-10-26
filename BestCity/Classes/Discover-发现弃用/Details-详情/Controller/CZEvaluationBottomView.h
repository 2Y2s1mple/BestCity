//
//  CZEvaluationBottomView.h
//  BestCity
//
//  Created by JasonBourne on 2019/10/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEvaluationBottomView : UIView
+ (instancetype)evaluationBottomView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *paramDic;
/** <#注释#> */
@property (nonatomic, strong) void (^bugBlock)(void);
@end

NS_ASSUME_NONNULL_END
