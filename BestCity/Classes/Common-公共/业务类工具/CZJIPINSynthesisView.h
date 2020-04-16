//
//  CZJIPINSynthesisView.h
//  BestCity
//
//  Created by JasonBourne on 2020/3/24.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZJIPINSynthesisView : UIView
/** 全局分享统一UI*/
+ (void)JIPIN_UMShareUIWithAction:(void (^)(CZJIPINSynthesisView *view, NSInteger index))action;

#pragma mark -  /** 全局分享统一UI, 样式2*/
+ (void)JIPIN_UMShareUI2WithAction:(void (^)(CZJIPINSynthesisView *view, NSInteger index))action;

@end

NS_ASSUME_NONNULL_END
