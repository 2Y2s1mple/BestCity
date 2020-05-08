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
#import "CZIssueMomentsAlertView.h"
#import "GXNetTool.h"


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
        @{@"icon" : @"share-1", @"name" : @"微信"},
        @{@"icon" : @"share-3", @"name" : @"朋友圈"},
        @{@"icon" : @"share-4", @"name" : @"QQ"},
        @{@"icon" : @"moments-6", @"name" : @"微博"},
        @{@"icon" : @"share-5", @"name" : @"批量存图"},
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

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)action:(UITapGestureRecognizer *)tap
{
    [CZProgressHUD showProgressHUDWithText:nil];
    [CZProgressHUD hideAfterDelay:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });

//    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
//    posteboard.string = self.mutStr;
    // 增加访问量
    [self addComment];

    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (tap.view.tag - 100) {
        case 0:
        {
            [CZJIPINSynthesisTool JINPIN_systemShareImages:self.images success:^(BOOL completed) {
                if (completed) {
                    [self addComment];
                }
            }];
            break;
        }
        case 1: // 朋友圈
        {
            [CZJIPINSynthesisTool jipin_saveImage:self.images];
            CURRENTVC(currentVc);
            CZIssueMomentsAlertView *vc = [[CZIssueMomentsAlertView alloc] init];
            [currentVc presentViewController:vc animated:NO completion:nil];
            break;
        }
        case 2:
        {
            [CZProgressHUD showProgressHUDWithText:@"文案已复制到粘贴板, 分享后长按粘贴"];
            [CZProgressHUD hideAfterDelay:1.5];
            [CZJIPINSynthesisTool JINPIN_systemShareImages:self.images success:^(BOOL completed) {
                if (completed) {
                    [self addComment];
                }
            }];
            break;
        }
        case 3:
        {
            [CZProgressHUD showProgressHUDWithText:@"文案已复制到粘贴板, 分享后长按粘贴"];
            [CZProgressHUD hideAfterDelay:1.5];
            type = UMSocialPlatformType_Sina;//微博
            [CZJIPINSynthesisTool JINPIN_systemShareImages:self.images success:^(BOOL completed) {
                if (completed) {
                    [self addComment];
                }
            }];
            break;
        }
        case 4:
        {
            [CZJIPINSynthesisTool jipin_saveImage:self.images];
            break;
        }
        default:
            break;
    }
}

// 增加访问量
- (void)addComment
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"momentId"] = self.momentId;

    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/moment/addShare"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
             NSInteger count = [self.shareNumber.text integerValue];
            self.shareNumber.text = [NSString stringWithFormat:@"%ld", ++count];
        }
    } failure:^(NSError *error) {}];
}


@end
