//
//  CZUMConfigure.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZUMConfigure.h"
#import <UMCommon/UMCommon.h>
#import <UShareUI/UShareUI.h>

@implementation CZUMConfigure
static id _instance;
+ (instancetype)shareConfigure
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)configure{
    
    [UMConfigure initWithAppkey:@"5b729a75f29d987629000096" channel:@"App Store"];
    // U-Share 平台设置
    [self configUSharePlatforms];
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8f070e5ba0894216" appSecret:@"04bf7bb2c4238f66bcee8b9ce8bf721e" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    NSString *qqAppID = @"1105413597";
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:qqAppID/*设置QQ平台的appID*/ appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"172365838" appSecret:@"13ee1cbda6b273ec4ee4dd522e9c74b8" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

- (void)shareToPlatformType:(UMSocialPlatformType)platformType currentViewController:(UIViewController *)vc webUrl:(NSString *)webUrl Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage
{
    //    //设置图片内容对象
    //    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //    shareObject.thumbImage = [UIImage imageNamed:@"icon.png"];//如果有缩略图，则设置缩略图
    //    [shareObject setShareImage:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534319537557&di=f5dcb1f44d10702889212857acdb5371&imgtype=0&src=http%3A%2F%2Fwww.qqma.com%2Fimgpic2%2Fcpimagenew%2F2018%2F4%2F5%2F6e1de60ce43d4bf4b9671d7661024e7a.jpg"];
    
    // 设置网页
    UMShareWebpageObject *shareUrlObject = [UMShareWebpageObject shareObjectWithTitle:title descr:subTitle thumImage:thumImage];
    //设置网页地址
    shareUrlObject.webpageUrl = webUrl;
    
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareUrlObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
@end
