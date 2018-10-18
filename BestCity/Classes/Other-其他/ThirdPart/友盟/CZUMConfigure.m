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
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    NSString *qqAppID = @"1107690249";
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:qqAppID/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1438884882"  appSecret:@"2a0c703950acf79e36f14b222ac54e00" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

- (void)shareToPlatformType:(UMSocialPlatformType)platformType currentViewController:(UIViewController *)vc
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"如果好友通过您分享的链接完成购买，您即可获得10%的佣金，并可提现到支付宝账户。";
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon.png"];
    [shareObject setShareImage:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534319537557&di=f5dcb1f44d10702889212857acdb5371&imgtype=0&src=http%3A%2F%2Fwww.qqma.com%2Fimgpic2%2Fcpimagenew%2F2018%2F4%2F5%2F6e1de60ce43d4bf4b9671d7661024e7a.jpg"];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
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
