//
//  GXButtons.h
//  GXLCodeRepository
//
//  Created by JasonBourne on 2020/3/19.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^btnBlock)(UIButton *);

@interface GXButtons : UIView
/** 用颜色文字自定义 */
+ (instancetype)buttonWithFrame:(CGRect)rect title:(NSString *)title bColor:(UIColor *)backColor color:(UIColor *)color font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius
eventBlock:(btnBlock)block;

/**  加载单独一个图片 */
+ (instancetype)buttonWithFrame:(CGRect)rect backImage:(UIImage *)bImage bColor:(UIColor *)backColor cornerRadius:(CGFloat)cornerRadius eventBlock:(btnBlock)block;

@end

NS_ASSUME_NONNULL_END
