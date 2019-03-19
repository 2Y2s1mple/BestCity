//
//  CZInvitationController.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZInvitationController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"
#import "UIImageView+WebCache.h"
#import "CZUMConfigure.h"

@interface CZInvitationController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigImageConstraint;
/** 后台返回的图片 */
@property (nonatomic, strong) NSDictionary *shareImageDic;
/** <#注释#> */
@property (nonatomic, weak)IBOutlet UIImageView *QRCodeImage;

@end

@implementation CZInvitationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getShareImage];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"邀请好友" rightBtnTitle:nil rightBtnAction:nil navigationViewType:nil];
    self.bigImageConstraint.constant = CZGetY(navigationView);
    self.bottomViewConstraint.constant = (IsiPhoneX ? 34 : 0);
    
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    [self.view addSubview:navigationView];
}

- (void)getShareImage
{
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/user/getQRcodeImg"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            self.shareImageDic = result[@"data"];
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:nil];
}

- (void)setShareImageDic:(NSDictionary *)shareImageDic
{
    _shareImageDic = shareImageDic;
    [self.QRCodeImage sd_setImageWithURL:[NSURL URLWithString:shareImageDic[@"qrcodeImg"]]];
}

- (IBAction)action:(UIButton *)sender
{
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;//未知的
    switch (sender.tag - 100) {
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
    //设置图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    shareObject.thumbImage = [UIImage imageNamed:@"icon.png"];
    //如果有缩略图，则设置缩略图
    [shareObject setShareImage:self.shareImageDic[@"posterImg"]];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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
