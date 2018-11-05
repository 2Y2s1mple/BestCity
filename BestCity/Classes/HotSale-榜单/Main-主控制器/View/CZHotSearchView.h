//
//  CZHotSearchView.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/3.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CZHotSearchView : UIView
/** 右边消息 */
@property (nonatomic, copy) void (^msgBlock)(void);
/** 必须设置文本框是否允许输入 */
@property (nonatomic, assign, getter=isTextFieldActive) BOOL textFieldActive;
- (instancetype)initWithFrame:(CGRect)frame msgAction:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
