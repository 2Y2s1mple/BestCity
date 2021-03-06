//
//  CZJIPINSynthesisView.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/24.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZJIPINSynthesisView.h"
#import "Masonry.h"
#import "CZShareItemButton.h"
#import "CZJIPINSynthesisTool.h"

@interface CZJIPINSynthesisView ()
/** <#注释#> */
@property (nonatomic, strong) void (^block)(CZJIPINSynthesisView *, NSInteger);
@end

@implementation CZJIPINSynthesisView
#pragma mark -  /** 全局分享统一UI*/
+ (void)JIPIN_UMShareUIWithAction:(void (^)(CZJIPINSynthesisView *view, NSInteger index))action
{
    ISPUSHLOGIN;
    [CZJIPINSynthesisTool jipin_authTaobaoSuccess:^(BOOL isAuth){
        if (isAuth) {
            [self UMShareUIWithAction:action];
        }
    }];
}

+ (void)UMShareUIWithAction:(void (^)(CZJIPINSynthesisView *view, NSInteger index))action
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    CZJIPINSynthesisView *backView = [[CZJIPINSynthesisView alloc] init];
    backView.block = action;
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backView action:@selector(dismiss:)];
    [backView addGestureRecognizer:tap];

    [window addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(window);
    }];

    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.bottom.equalTo(backView);
        make.width.equalTo(@(SCR_WIDTH));
        make.height.equalTo(@(130));
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    [shareView addSubview:titleLabel];
    titleLabel.text = @"分享到";
    titleLabel.textColor = UIColorFromRGB(0x565252);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareView);
        make.top.equalTo(@(8));
    }];

    CGFloat space = (SCR_WIDTH - 50 * 5) / 6.0;
    NSArray *imageArr = @[
        @{@"icon" : @"share-1", @"name" : @"微信"},
        @{@"icon" : @"share-3", @"name" : @"朋友圈"},
        @{@"icon" : @"share-4", @"name" : @"QQ"},
        @{@"icon" : @"moments-6", @"name" : @"微博"},
        @{@"icon" : @"share-5", @"name" : @"保存图片"},
                        ];
    [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CZShareItemButton *imageView = [CZShareItemButton buttonWithType:UIButtonTypeCustom];
        imageView.adjustsImageWhenHighlighted = NO;
        [imageView setImage:[UIImage imageNamed:obj[@"icon"]] forState:UIControlStateNormal];
        [imageView setTitle:obj[@"name"] forState:UIControlStateNormal];
        imageView.frame = CGRectMake((space + 50) * idx + 25, 47, 50, 60);
        imageView.tag = idx + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backView action:@selector(shareAction:)];
        [imageView addGestureRecognizer:tap];
        [shareView addSubview:imageView];
    }];
}




#pragma mark -  /** 全局分享统一UI, 样式2*/
+ (void)JIPIN_UMShareUI2WithAction:(void (^)(CZJIPINSynthesisView *view, NSInteger index))action
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    CZJIPINSynthesisView *backView = [[CZJIPINSynthesisView alloc] init];
    backView.block = action;
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backView action:@selector(dismiss:)];
    [backView addGestureRecognizer:tap];
    [window addSubview:backView];
    
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(window);
    }];
    
    
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.bottom.equalTo(backView);
        make.width.equalTo(@(SCR_WIDTH));
        make.height.equalTo(@(200));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"分享至";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabel.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0];
    [shareView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareView).offset(20);
        make.centerX.equalTo(shareView);
    }];


    CGFloat space = SCR_WIDTH / 7.0;
    NSArray *imageArr = @[@{@"icon" : @"wechat", @"name" : @"微信好友"}, @{@"icon" : @"pyq", @"name" : @"朋友圈"}, @{@"icon" : @"weibo", @"name" : @"微博"}];
    [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CZShareItemButton *imageView = [CZShareItemButton buttonWithType:UIButtonTypeCustom];
        imageView.adjustsImageWhenHighlighted = NO;
        [imageView setImage:[UIImage imageNamed:obj[@"icon"]] forState:UIControlStateNormal];
        [imageView setTitle:obj[@"name"] forState:UIControlStateNormal];
        imageView.frame = CGRectMake(space * ((idx +  1) * 2 - 1), 57, 50, 60);
        imageView.tag = idx + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backView action:@selector(shareAction:)];
        [imageView addGestureRecognizer:tap];
        [shareView addSubview:imageView];
        
    }];

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [shareView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(shareView);
        make.width.equalTo(shareView);
        make.height.equalTo(@(1));
        make.bottom.equalTo(@(-50));
    }];
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC" size: 16];
    [btn setTitleColor:UIColorFromRGB(0x9D9D9D) forState:UIControlStateNormal];
    [shareView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line);
        make.right.left.bottom.equalTo(shareView);
    }];
    [btn addTarget:shareView action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 事件
- (void)dismiss:(UIGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

- (void)shareAction:(UIGestureRecognizer *)tap
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
    !self.block ? : self.block(self, tap.view.tag - 100);
}

@end
