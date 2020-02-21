//
//  CZRedPacketsShareView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/21.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsShareView.h"
#import "Masonry.h"
#import "CZUMConfigure.h"
#import "CZShareItemButton.h"

@implementation CZRedPacketsShareView

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
        @{@"icon" : @"wechat", @"name" : @"微信邀请"},
        @{@"icon" : @"pyq", @"name" : @"微信群邀请"},
        @{@"icon" : @"weibo", @"name" : @"朋友圈邀请"},
        @{@"icon" : @"weibo", @"name" : @"qq邀请"},
        @{@"icon" : @"weibo", @"name" : @"图片邀请"},
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
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (tap.view.tag - 100) {
        case 0:
            type = UMSocialPlatformType_WechatSession;//微信好友
            break;
        case 1:
            type = UMSocialPlatformType_WechatSession;//微信好友
            break;
        case 2:
            type = UMSocialPlatformType_WechatTimeLine;//微信朋友圈
            break;
        case 3:
            type = UMSocialPlatformType_QQ;//QQ好友
            break;
        case 4:
            type = UMSocialPlatformType_Qzone;//QQ空间
            break;
        default:
            break;
    }

    if (![[UMSocialManager defaultManager] isInstall:type]) {
        [CZProgressHUD showProgressHUDWithText:@"没有安装该平台!"];
        [CZProgressHUD hideAfterDelay:2];
        return;
    }

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;

//    if (self.shareTypeParam == nil) {
//        self.shareTypeParam = @{@"type" : @"998", @"object" : @""};
//    }
//
//    [[CZUMConfigure shareConfigure] shareToPlatformType:type currentViewController:currentVc webUrl:self.param[@"shareUrl"] Title:self.param[@"shareTitle"] subTitle:self.param[@"shareContent"] thumImage:self.param[@"shareImg"] shareType:[self.shareTypeParam[@"type"] integerValue] object:self.shareTypeParam[@"object"]];

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = self.paramDic[@"content"];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:currentVc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];

}


@end
