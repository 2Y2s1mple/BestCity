//
//  GXButtons.m
//  GXLCodeRepository
//
//  Created by JasonBourne on 2020/3/19.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "GXButtons.h"



@interface GXButtons ()
/** void */
@property (nonatomic, strong) btnBlock block;
@end

@implementation GXButtons

// 用颜色文字自定义
+ (instancetype)buttonWithFrame:(CGRect)rect title:(NSString *)title bColor:(UIColor *)backColor color:(UIColor *)color font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius eventBlock:(btnBlock)block
{
    GXButtons *backView = [[GXButtons alloc] init];
    backView.block = block;
    backView.frame = rect;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = rect.size;
    btn.backgroundColor = backColor;
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [backView addSubview:btn];
    btn.layer.cornerRadius = cornerRadius;
    [btn addTarget:backView action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    return backView;
}

// 加载单独一个图片
+ (instancetype)buttonWithFrame:(CGRect)rect backImage:(UIImage *)bImage bColor:(UIColor *)backColor cornerRadius:(CGFloat)cornerRadius eventBlock:(btnBlock)block
{
    if (CGRectIsNull(rect)) {
        NSLog(@"是");
    } else {
        NSLog(@"否");
    }
    GXButtons *backView = [[GXButtons alloc] init];
    backView.block = block;
    backView.frame = rect;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = rect.size;
    btn.backgroundColor = backColor;
    btn.layer.cornerRadius = cornerRadius;
    [backView addSubview:btn];
    if (bImage) {
        [btn setImage:bImage forState:UIControlStateNormal];
    }
    [btn addTarget:backView action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    return backView;
}

#pragma mark - 事件
- (void)action:(UIButton *)sender
{
    !self.block ? : self.block(sender);
}


@end
