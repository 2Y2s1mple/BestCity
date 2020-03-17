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
#import "UIImageView+WebCache.h"

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

    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (tap.view.tag - 100) {
        case 0:
            type = UMSocialPlatformType_WechatSession;//微信好友
            [self shareTextWithType:type text:self.paramDic[@"content"]];
            break;
        case 1:
            type = UMSocialPlatformType_WechatSession;//微信好友
            [self shareTextWithType:type text:self.paramDic[@"content"]];
            break;
        case 2:
            type = UMSocialPlatformType_WechatTimeLine;//微信朋友圈
            [self shareImageWithType:type thumImage:self.paramDic[@"posterImg"]];
            break;
        case 3:
            type = UMSocialPlatformType_QQ;//QQ好友
            [self shareTextWithType:type text:self.paramDic[@"content"]];
            break;
        case 4:
        {
            // 保存图片
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.paramDic[@"posterImg"]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

                NSLog(@"%@", image);
                [self saveImageWithImage:image];
            }];
            break;
        }
        default:
            break;
    }
}

// 分享纯文字
- (void)shareTextWithType:(UMSocialPlatformType)type text:(NSString *)text
{
    if (![[UMSocialManager defaultManager] isInstall:type]) {
        [CZProgressHUD showProgressHUDWithText:@"没有安装该平台!"];
        [CZProgressHUD hideAfterDelay:2];
        return;
    }
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = text; //self.paramDic[@"content"];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:currentVc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


// 分享图片
- (void)shareImageWithType:(UMSocialPlatformType)type thumImage:(NSString *)thumImage
{
    if (![[UMSocialManager defaultManager] isInstall:type]) {
        [CZProgressHUD showProgressHUDWithText:@"没有安装该平台!"];
        [CZProgressHUD hideAfterDelay:2];
        return;
    }
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    shareObject.thumbImage = [UIImage imageNamed:@"launchLogo.png"];//如果有缩略图，则设置缩略图
    [shareObject setShareImage:thumImage];
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:currentVc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


// 保存图片
- (void)saveImageWithImage:(UIImage *)image
{
    //参数1:图片对象
    //参数2:成功方法绑定的target
    //参数3:成功后调用方法
    //参数4:需要传递信息(成功后调用方法的参数)
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -- <保存到相册>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [CZProgressHUD showProgressHUDWithText:msg];
    }else{
        msg = @"保存图片成功" ;
        [CZProgressHUD showProgressHUDWithText:msg];
    }
    [CZProgressHUD hideAfterDelay:1.5];
}


@end
