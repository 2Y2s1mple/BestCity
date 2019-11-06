//
//  CZEvaluateToolBar.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/12.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^toolBarActionBlock)(void);

@interface CZEvaluateToolBar : UIView
/** 文本框 */
@property (nonatomic, strong) UITextView *textView;
@property (strong, nonatomic) UIButton *senderBtn;
+ (instancetype)evaluateToolBar;
/** block */
@property (nonatomic, copy) toolBarActionBlock block;
/** placeHolder */
@property (nonatomic, strong) NSString *placeHolderText;
/** <#注释#> */
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

NS_ASSUME_NONNULL_END
