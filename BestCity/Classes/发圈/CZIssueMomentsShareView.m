//
//  CZIssueMomentsShareView.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZIssueMomentsShareView.h"
#import "Masonry.h"
#import "CZUMConfigure.h"
#import "CZShareItemButton.h"
#import "UIImageView+WebCache.h"

@implementation CZIssueMomentsShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}


- (void)setupSubView
{
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(SCR_WIDTH));
        make.height.equalTo(@(93));
    }];

    CGFloat space = (SCR_WIDTH - 50 * 5) / 6.0;
    NSArray *imageArr = @[
        @{@"icon" : @"share-1", @"name" : @"微信邀请"},
        @{@"icon" : @"share-2", @"name" : @"微信群邀请"},
        @{@"icon" : @"share-3", @"name" : @"朋友圈邀请"},
        @{@"icon" : @"share-4", @"name" : @"qq邀请"},
        @{@"icon" : @"share-5", @"name" : @"图片邀请"},
                        ];
    [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CZShareItemButton *imageView = [CZShareItemButton buttonWithType:UIButtonTypeCustom];
        imageView.adjustsImageWhenHighlighted = NO;
        [imageView setImage:[UIImage imageNamed:obj[@"icon"]] forState:UIControlStateNormal];
        [imageView setTitle:obj[@"name"] forState:UIControlStateNormal];
        imageView.frame = CGRectMake((space + 50) * idx + 25, 18, 50, 60);
        imageView.tag = idx + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [imageView addGestureRecognizer:tap];
        [shareView addSubview:imageView];

    }];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];

    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(shareView.mas_top);
    }];
}



@end
