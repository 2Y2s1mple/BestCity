//
//  CZEvaluationSearchView.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEvaluationSearchView : UIView
/** 点击的事件 */
@property (nonatomic, strong) void (^didClickedSearchView)(void);
@end

NS_ASSUME_NONNULL_END
