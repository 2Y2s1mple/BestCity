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
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
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
    if (webUrl.length == 0) {
        webUrl = @"https://www.jipincheng.cn";
    }

    if ([thumImage isKindOfClass:[NSString class]] && thumImage.length == 0) {
        thumImage = [UIImage imageNamed:@"headDefault"];
    }

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (platformType == UMSocialPlatformType_WechatSession) {
        if (type == 0) { // 0元购
            //分享消息对象设置分享内容对象
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-info/index?freeId=%@", anObject]];
        } else if (type == 10) { // 免单老人页面
            //分享消息对象设置分享内容对象
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-v2-list/index?fromUserId=%@", JPUSERINFO[@"userId"]]];
        } else if (type == 11) { // 免单老人详情
            //分享消息对象设置分享内容对象
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-v2-info/index?id=%@&fromUserId=%@", anObject, JPUSERINFO[@"userId"]]];
        } else if (type == 12) { // 新人详情页面
            //分享消息对象设置分享内容对象
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-new-info/index?id=%@&fromUserId=%@", anObject, JPUSERINFO[@"userId"]]];
        } else if (type == 1) { // 商品
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b0a86c45468d" path:[NSString stringWithFormat:@"pages/list/top-info/main?topListVal=%@", anObject]];
        } else if (type == 2) { // 评测
            //设置分享内容
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b0a86c45468d" path:[NSString stringWithFormat:@"pages/ev/ev-info/main?evListVal=%@", anObject]];
        } else if (type == 3) { // 网页
            //设置分享内容
            messageObject.shareObject = [self setUpWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage];
        } else if (type == 998) {
            //设置分享内容
            messageObject.shareObject = [self setUpWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage];
        } else {
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            shareObject.thumbImage = [UIImage imageNamed:@"launchLogo.png"];//如果有缩略图，则设置缩略图
            [shareObject setShareImage:thumImage];
            messageObject.shareObject = shareObject;

        }
    } else {
        if (type == 998) {
            //设置分享内容
            messageObject.shareObject = [self setUpWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage];
        } else {
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            shareObject.thumbImage = [UIImage imageNamed:@"launchLogo.png"];//如果有缩略图，则设置缩略图
            [shareObject setShareImage:thumImage];
            messageObject.shareObject = shareObject;
        }

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
//    thumImage = [UIImage imageNamed:@"launchLogo.png"];




    NSData *currentImageData;
    if ([thumImage isKindOfClass:[UIImage class]]) {
        UIImage* newImage = thumImage;
        NSData *imageData =  UIImagePNGRepresentation(newImage);
        NSInteger length = [imageData length];
        CGFloat compression;
        if ([imageData length] > 127000) {
            compression =  127000.0 / length;
        } else {
            compression = 1;
        }
        currentImageData =  UIImageJPEGRepresentation(newImage, compression);
    } else {

        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumImage]];
        UIImage* newImage = [UIImage imageWithData:data];
        NSData *imageData =  UIImagePNGRepresentation(newImage);
        NSInteger length = [imageData length];
        CGFloat compression;
        if ([imageData length] > 127000) {
            compression =  127000.0 / length;
        } else {
            compression = 0.9;
        }
        currentImageData =  UIImageJPEGRepresentation(newImage, compression);
    }


    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:subTitle thumImage:[UIImage imageWithData:currentImageData]];
    shareObject.webpageUrl = webUrl;
    shareObject.userName = userName;
    shareObject.path = path;
    shareObject.hdImageData = currentImageData;


    shareObject.miniProgramType = UShareWXMiniProgramTypeRelease; // 可选体验版和开发板
    return shareObject;
}

- (void)sharePlatform:(UMSocialPlatformType)platform controller:(UIViewController *)vc url:(NSString *)webUrl Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(id)thumImage shareType:(CZUMConfigureType)type object:(id)anObject
{
    if (webUrl.length == 0) {
        webUrl = @"https://www.jipincheng.cn";
    }

    if ([thumImage isKindOfClass:[NSString class]] && [thumImage length] == 0) {
        thumImage = [UIImage imageNamed:@"headDefault"];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    switch (type) {
        case CZUMConfigureTypeMiniProgramFree:
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-info/index?freeId=%@", anObject]];
            break;
        case CZUMConfigureTypeMiniProgramFreeOldUserList:
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-v2-list/index?fromUserId=%@", JPUSERINFO[@"userId"]]];
            break;
        case CZUMConfigureTypeMiniProgramFreeOldUserDetail:
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-v2-info/index?id=%@&fromUserId=%@", anObject, JPUSERINFO[@"userId"]]];
            break;
        case CZUMConfigureTypeMiniProgramFreeNewUserDetail:
             messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b92a56fb45d1" path:[NSString stringWithFormat:@"pages/main/main-new-info/index?id=%@&fromUserId=%@", anObject, JPUSERINFO[@"userId"]]];
            break;
        case CZUMConfigureTypeMiniProgramGoods:
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b0a86c45468d" path:[NSString stringWithFormat:@"pages/list/top-info/main?topListVal=%@", anObject]];
            break;
        case CZUMConfigureTypeMiniProgramEvaluate:
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b0a86c45468d" path:[NSString stringWithFormat:@"pages/ev/ev-info/main?evListVal=%@", anObject]];
            break;
        case CZUMConfigureTypeWeb:
            messageObject.shareObject = [self setUpWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage];
            break;
        case CZUMConfigureTypeImage:
        {
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            shareObject.thumbImage = [UIImage imageNamed:@"launchLogo.png"];//如果有缩略图，则设置缩略图
            [shareObject setShareImage:thumImage];
            messageObject.shareObject = shareObject;
            break;
        }
        case 1125:
        {
            messageObject.shareObject = [self setUpMiniWebUrl:webUrl Title:title subTitle:subTitle thumImage:thumImage userName:@"gh_b0a86c45468d" path:[NSString stringWithFormat:@"pages/list/main-v2-info/main?id=%@", anObject]];
            break;
        }
        default:
            break;
    }





    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            UMSocialShareResponse *dataResponse = data;
            NSLog(@"response data is %@", dataResponse.message);
            [CZGetJIBITool getJiBiWitType:@(5)];
        }
    }];
}

@end
