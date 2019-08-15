//
//  CZNavigationView.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CZNavigationViewDelegate <NSObject>
@optional
- (void)popViewController;
@end

typedef void(^rightBtnBlock)(void);

@interface CZNavigationView : UIView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title rightBtnTitle:(id)rightBtnTitle rightBtnAction:(rightBtnBlock)rightBtnAction;

@property (nonatomic, assign) id <CZNavigationViewDelegate> delegate;

/** 右边的按钮颜色 */
@property (nonatomic, strong) UIColor *rightBtnTextColor;
@end
