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
- (void)didClickedTitleWithIndex:(NSInteger)index;
@end


@interface CZRecommendNav : UIView
/** <#注释#> */
@property (nonatomic, weak) id <CZRecommendNavDelegate> delegate;
/** 监听vc中scroller的滚动 */
@property (nonatomic, assign) NSInteger monitorIndex;
/** 是否收藏 */
@property (nonatomic, assign) BOOL isCollect;
/** <#注释#> */
@property (nonatomic, copy) void(^rightClickedBlock)(BOOL);
@end
