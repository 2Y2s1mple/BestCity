//
//  CZEditorTextView.h
//  BestCity
//
//  Created by JasonBourne on 2019/5/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZEditorTextView : UITextView
/** 标题文本 */
@property (nonatomic, copy) void (^titleTextBlock) (NSString *);
/** 内容文本 */
@property (nonatomic, copy) void (^textBlock) (NSString *, CGFloat);
/** <#注释#> */
@property (nonatomic, strong) NSString *placeHolder;
/** 默认文字 */
@property (nonatomic, strong) NSString *defaultText;
@end

NS_ASSUME_NONNULL_END
