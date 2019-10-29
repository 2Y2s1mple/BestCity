//
//  CZTabbar.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/29.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTabbar.h"
#import "CZFestivalController.h"
#import "CZNavigationController.h"

@interface CZTabbar ()
/** <#注释#> */
@property (nonatomic, strong) UIButton *festivalButton;
@end

@implementation CZTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//        // 添加活动按钮
//        UIButton *festivalButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [festivalButton setBackgroundImage:[UIImage imageNamed:@"festival-tab"] forState:UIControlStateNormal];
//        [festivalButton setBackgroundImage:[UIImage imageNamed:@"festival-tab"] forState:UIControlStateHighlighted];
//        festivalButton.size = festivalButton.currentBackgroundImage.size;
//        [self addSubview:festivalButton];
//        self.festivalButton = festivalButton;
//        [festivalButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)publishClick
{
//    XMGPublishViewController *publish = [[XMGPublishViewController alloc] init];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publish animated:NO completion:nil];

//    CZFestivalController *postWord = [[CZFestivalController alloc] init];
//    CZNavigationController *nav = [[CZNavigationController alloc] initWithRootViewController:postWord];
//
//    // 这里不能使用self来弹出其他控制器, 因为self执行了dismiss操作
//    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//    [root presentViewController:nav animated:YES completion:nil];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;

    UITabBarItem *barItem = self.items[2];

    // 调整其他按钮大小
    NSInteger index = 0;
    for (UIButton *btn in self.subviews) {
        if (![btn isKindOfClass:[UIControl class]]) continue;
        // 计算按钮的x值
        if (barItem.title.length == 0 && index == 2) {
            btn.center = CGPointMake(width / 2.0, height / 2.0 + 7);
        }
        // 增加索引
        index++;
    }
}
@end
