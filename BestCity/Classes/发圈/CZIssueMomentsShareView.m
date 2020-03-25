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
            [self shareToSocial];
            break;
        }
        case 1: // 朋友圈
            [self saveImageWithImage];
            break;
        case 2:
        {
            [CZProgressHUD showProgressHUDWithText:@"文案已复制到粘贴板, 分享后长按粘贴"];
            [CZProgressHUD hideAfterDelay:1.5];
            [self shareToSocial];
            break;
        }
        case 3:
        {
            [CZProgressHUD showProgressHUDWithText:@"文案已复制到粘贴板, 分享后长按粘贴"];
            [CZProgressHUD hideAfterDelay:1.5];
            type = UMSocialPlatformType_Sina;//微博
            [self shareToSocial];
            break;
        }
        case 4:
        {
            [self saveImageWithImage];
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
            NSLog(@"************Share fail with error %@*********", error);
        } else {
            NSLog(@"response data is %@", data);
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
- (void)saveImageWithImage
{
    //参数1:图片对象
    //参数2:成功方法绑定的target
    //参数3:成功后调用方法
    //参数4:需要传递信息(成功后调用方法的参数)

    if (self.images.count > 0) {
        UIImage *image = self.images[0];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        CZIssueMomentsAlertView *vc = [[CZIssueMomentsAlertView alloc] init];
        CURRENTVC(currentVc);
        [currentVc presentViewController:vc animated:NO completion:nil];
    }

}

#pragma mark -- <保存到相册>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [CZProgressHUD showProgressHUDWithText:msg];
        [CZProgressHUD hideAfterDelay:1.5];
    }else{
        msg = @"保存图片成功" ;
        [self.images removeObjectAtIndex:0];
        [self saveImageWithImage];
    }

}


-(void)shareToSocial
{
    NSArray *activityItems = self.images;

    UIActivityViewController * activityViewController = [[UIActivityViewController alloc]
                                                         initWithActivityItems:activityItems applicationActivities:nil];

//    设定不想显示的平台和功能
    NSArray *excludeArray = @[
        UIActivityTypeAirDrop,
        UIActivityTypePrint,
        UIActivityTypePostToVimeo,
        UIActivityTypeMessage,
        UIActivityTypeMail,
    ];
//不需要分享的图标
    activityViewController.excludedActivityTypes = excludeArray;


    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable   activityType,
                                            BOOL completed,
                                            NSArray * _Nullable returnedItems,
                                            NSError * _Nullable activityError) {

        NSLog(@"activityType: %@,\n completed: %d,\n returnedItems:%@,\n activityError:%@",activityType,completed,returnedItems,activityError);
        // 增加访问量
        if (completed) {
            [self addComment];
        }
    };


    CURRENTVC(currentVc)
    [currentVc presentViewController: activityViewController animated: YES completion: nil];

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
