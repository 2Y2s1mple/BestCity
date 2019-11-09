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
#import <UMAnalytics/MobClick.h>
#import "CZGetJIBITool.h"
#import "UIImageView+WebCache.h"

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
//     [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO
    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景
//    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxfd2e92db2568030a" appSecret:@"80b12d76b891c37a6ccc47bc0b651713" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    NSString *qqAppID = @"1105413597";
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:qqAppID/*设置QQ平台的appID*/ appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2148903410" appSecret:@"8d3c2285a9a46b5e4f36656874c0c188" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

- (void)shareToPlatformType:(UMSocialPlatformType)platformType currentViewController:(UIViewController *)vc webUrl:(NSString *)webUrl Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage shareType:(NSInteger)type object:(id)anObject
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (platformType == UMSocialPlatformType_WechatSession) {
        if (type == 0) { // 0元购
            //分享消息对象设置分享内容对象
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-info/index?freeId=%@", anObject]];
        } else if (type == 1) { // 商品
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b0a86c45468d" path:[NSString stringWithFormat:@"pages/list/top-info/main?topListVal=%@", anObject]];
        } else if (type == 2) { // 评测
            //设置分享内容
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b0a86c45468d" path:[NSString stringWithFormat:@"pages/ev/ev-info/main?evListVal=%@", anObject]];
        } else {
            //设置分享内容
            messageObject.shareObject = [self setUpWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage];
        }
    } else {
        //设置分享内容
        messageObject.shareObject = [self setUpWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage];
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            UMSocialShareResponse *dataResponse = data;
            NSLog(@"response data is %@", dataResponse.message);
            [CZGetJIBITool getJiBiWitType:@(5)];
        }
    }];
}


// 网页形式
- (UMShareWebpageObject *)setUpWebUrl:(NSString *)webUrl Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage
{
    // 设置网页
    UMShareWebpageObject *shareUrlObject = [UMShareWebpageObject shareObjectWithTitle:title descr:subTitle thumImage:thumImage];
    //设置网页地址
    shareUrlObject.webpageUrl = webUrl;
    return shareUrlObject;
}

// 小程序形式
- (UMShareMiniProgramObject *)setUpMiniWebUrl:(NSString *)webUrl Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage userName:(NSString *)userName path:(NSString *)path
{
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:subTitle thumImage:thumImage];
    shareObject.webpageUrl = webUrl;
    shareObject.userName = userName;
    shareObject.path = path;

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumImage]];
    UIImage* newImage = [UIImage imageWithData:data];
    NSData *imageData =  UIImagePNGRepresentation(newImage);
    NSInteger length = [imageData length];
    CGFloat compression;
    if ([imageData length] > 127000) {
        compression =  127000.0 / length;
    } else {
        compression = 1;
    }

    imageData =  UIImageJPEGRepresentation(newImage, compression);
    shareObject.hdImageData = imageData;
    shareObject.miniProgramType = UShareWXMiniProgramTypeRelease; // 可选体验版和开发板
    return shareObject;
}



@end
