//
//  CZShareView.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZShareView.h"
#import "Masonry.h"
#import "CZUMConfigure.h"
#import "CZShareItemButton.h"

#define PLACEHOLDERTAG 100
@implementation CZShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
    [self setupSubView];
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
        make.height.equalTo(@(SCR_HEIGHT / 3));
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

    //        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    //        make.left.equalTo(shareView).offset(20);
    //        make.right.equalTo(shareView).offset(-20);

    CGFloat space = SCR_WIDTH / 7.0;
    NSArray *imageArr = @[@{@"icon" : @"wechat", @"name" : @"微信好友"}, @{@"icon" : @"pyq", @"name" : @"朋友圈"}, @{@"icon" : @"weibo", @"name" : @"微博"}];
    [imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CZShareItemButton *imageView = [CZShareItemButton buttonWithType:UIButtonTypeCustom];
        imageView.adjustsImageWhenHighlighted = NO;
        [imageView setImage:[UIImage imageNamed:obj[@"icon"]] forState:UIControlStateNormal];
        [imageView setTitle:obj[@"name"] forState:UIControlStateNormal];
        imageView.frame = CGRectMake(space * ((idx +  1) * 2 - 1), 57, 50, 60);
        imageView.tag = idx + PLACEHOLDERTAG;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [imageView addGestureRecognizer:tap];
        [shareView addSubview:imageView];
        
    }];

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [shareView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.width.equalTo(self);
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
        make.right.left.bottom.equalTo(self);
    }];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

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

- (void)action:(UITapGestureRecognizer *)tap
{
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (tap.view.tag - PLACEHOLDERTAG) {
        case 0:
            type = UMSocialPlatformType_WechatSession;//微信好友
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;//微信朋友圈
            break;
        case 2:
            type = UMSocialPlatformType_Sina;//新浪微博
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

    if (self.shareTypeParam == nil) {
        self.shareTypeParam = @{@"type" : @"998", @"object" : @""};
    }

    [[CZUMConfigure shareConfigure] shareToPlatformType:type currentViewController:currentVc webUrl:self.param[@"shareUrl"] Title:self.param[@"shareTitle"] subTitle:self.param[@"shareContent"] thumImage:self.param[@"shareImg"] shareType:[self.shareTypeParam[@"type"] integerValue] object:self.shareTypeParam[@"object"]];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{  
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
//        
//        if (error) {
//            NSLog(@"%@", error);
//        } else {
//            UMSocialUserInfoResponse *resp = result;
//            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat unionid: %@", resp.unionId);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.unionGender);
//            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
//        }
//    }];
}

@end
