//
//  CZTaskView.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZTaskView;

@protocol CZTaskViewDelegate <NSObject>
@optional
- (void)updataTaskView:(CZTaskView *)taskView;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CZTaskView : UIView
/** 数据 */
@property (nonatomic, strong) NSDictionary *taskData;
/** 代理 */
@property (nonatomic, weak) id <CZTaskViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
