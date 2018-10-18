//
//  CZDatePickView.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/8.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZDatePickView;

typedef NS_ENUM(NSUInteger, CZDatePickViewType) {
    CZDatePickViewTypeDate,
    CZDatePickViewTypeOther,
};

@protocol CZDatePickViewDelegate <NSObject>
@optional
- (void)datePickView:(CZDatePickView *)pickView selectedDate:(NSString *)dateString;
@end

@interface CZDatePickView : UIView
/** 代理 */
@property (nonatomic, weak) id<CZDatePickViewDelegate> delegate;
+ (instancetype)datePickWithCurrentDate:(NSString *)dateString type:(CZDatePickViewType)type;
/** 判断类型 */
@property (nonatomic, assign) CZDatePickViewType type;
@end
