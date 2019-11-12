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
#import "UIImage+GIF.h"

@interface CZTabbar () <UITabBarDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CZTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"11.11" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = image;
        imageView.size = CGSizeMake(80, 46.5);
        imageView.contentMode = UIViewContentModeScaleAspectFill;

        [self addSubview:imageView];
        self.imageView = imageView;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCenterImageView:) name:@"selectedFastival" object:nil];
        
    }
    return self;
}

- (void)hideCenterImageView:(NSNotification *)sender
{
    if ([sender.userInfo[@"flag"] boolValue]) {
        self.imageView.size = CGSizeMake(68, 44);
        self.imageView.image = [UIImage imageNamed:@"festival-tab"];
        self.imageView.center = CGPointMake(self.width / 2.0, self.height / 2.0);
        if (IsiPhoneX) {
            self.imageView.y = 5;
        }
    } else {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"11.11" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
        self.imageView.image = image;
        self.imageView.size = CGSizeMake(80, 46.5);
        self.imageView.center = CGPointMake(self.width / 2.0, self.height / 2.0);
        if (IsiPhoneX) {
            self.imageView.y = 5;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;

    UITabBarItem *barItem = self.items[2];

    self.imageView.center = CGPointMake(self.width / 2.0, self.height / 2.0);
    if (IsiPhoneX) {
        self.imageView.y = 5;
    }
    self.imageView.hidden = YES;
    // 调整其他按钮大小
    NSInteger index = 0;
    for (UIButton *btn in self.subviews) {
        if (![btn isKindOfClass:[UIControl class]]) continue;
        // 计算按钮的x值
        if (barItem.title.length == 0 && index == 2) {
            btn.center = CGPointMake(width / 2.0, height / 2.0 + 7);
            self.imageView.hidden = NO;
        }
        // 增加索引
        index++;
    }


}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
