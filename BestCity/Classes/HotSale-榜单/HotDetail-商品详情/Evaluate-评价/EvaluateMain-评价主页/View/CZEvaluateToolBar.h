//
//  CZEvaluateToolBar.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/12.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEvaluateToolBar : UIView
/** 文本框 */
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *senderBtn;
+ (instancetype)evaluateToolBar;
@end

NS_ASSUME_NONNULL_END
