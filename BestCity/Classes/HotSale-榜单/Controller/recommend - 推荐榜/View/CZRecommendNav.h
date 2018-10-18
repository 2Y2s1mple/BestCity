//
//  CZRecommendNav.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZRecommendNavDelegate <NSObject>
@optional
- (void)recommendNavWithPop:(UIView *)view;

@end


@interface CZRecommendNav : UIView
/** <#注释#> */
@property (nonatomic, weak) id <CZRecommendNavDelegate> delegate;
@end
