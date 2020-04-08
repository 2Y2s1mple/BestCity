//
//  CZJIPINSynthesisTool.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZJIPINSynthesisTool.h"
#import "GXNetTool.h"
#import "Masonry.h"
#import "CZShareItemButton.h"

#import "UIImageView+WebCache.h"


#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>
#import "CZOpenAlibcTrade.h"
#import "CZUserInfoTool.h" // 用户信息
#import "CZUpdataView.h"
#import "CZAlertView3Controller.h"
#import "CZSubFreePreferentialController.h" // 特惠购

#import "GXSaveImageToPhone.h" //保存图片
#import "GXZoomImageView.h" // 图片放大


#import "CZGuessTypeTowView.h"
#import "CZGuessTypeOneView.h"
#import "CZAlertView4Controller.h"


#import "CZShareViewController.h"
#import "CZUMConfigure.h"


@interface CZJIPINSynthesisTool ()
/** <#注释#> */
@property (nonatomic, strong) void (^block)(void);
@end


@implementation CZJIPINSynthesisTool
#pragma mark - 判断是哪个模块
+ (NSString *)getModuleTypeNumber:(CZJIPINModuleType)type
{
     /** 1商品，2评测, 3发现，4试用 5百科 6相关百科*/
    NSString *number;
    switch (type) {
        case CZJIPINModuleHotSale: //商品 
            number = @"1";
            break;
        case CZJIPINModuleDiscover: //发现
            number = @"3";
            break;
        case CZJIPINModuleEvaluation: //评测
            number = @"2";
            break;
        case CZJIPINModuleTrail: //试用报告  
            number = @"4";
            break;
        case CZJIPINModuleBK: //百科
            number = @"5";
            break;
        case CZJIPINModuleRelationBK: //相关百科
            number = @"6";
        case CZJIPINModuleQingDan: //相关百科
            number = @"7";
            break;
        default:
            number = @"";
            break;
    }
    return number;
}

+ (CZJIPINModuleType)getModuleType:(NSInteger)typeNumber
{
    /** 1商品，2评测, 3发现，4试用 */
    //类型：0不跳转，1商品详情，2评测详情 3发现详情, 4试用  5评测类目，7清单详情
    CZJIPINModuleType type;
    switch (typeNumber) {
        case 1: //商品
            type = CZJIPINModuleHotSale;
            break;
        case 3: //发现
            type = CZJIPINModuleDiscover;
            break;
        case 2: // 评测
            type = CZJIPINModuleEvaluation;
            break;
        case 4: // 试用报告
            type = CZJIPINModuleTrail;
            break;
        case 41: // 试用报告
            type = CZJIPINModuleTrail;
            break;
        case 5: // 百科
            type = CZJIPINModuleBK;
            break;
        case 6: // 相关百科
            type = CZJIPINModuleRelationBK;
            break;
        case 7: // 清单详情
            type = CZJIPINModuleQingDan;
            break;
        case 71: // 清单详情
            type = CZJIPINModuleQingDan;
            break;
        default:
            type = 0;
            break;
    }
    return type;
}

#pragma mark - 关注工具
// 取消关注
+ (void)deleteAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = attentionUserId;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow/delete"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"已取消"]) {
            // 关注
            [CZProgressHUD showProgressHUDWithText:@"取关成功"];
            action();
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

// 新增关注
+ (void)addAttentionWithID:(NSString *)attentionUserId action:(void (^)(void))action
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"attentionUserId"] = attentionUserId;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/follow"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"关注成功"]) {
            [CZProgressHUD showProgressHUDWithText:@"关注成功"];
            action();
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        }
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];
}

#pragma mark - 0元购, 跳淘宝购买, 之后弹出特惠购
+ (void)buyBtnActionWithId:(NSString *)Id alertTitle:(NSString *)alertTitle
{
    [self jipin_authTaobaoSuccess:^(BOOL isAuth){
        if (isAuth) {
            if (alertTitle == nil ) {
                // 打开淘宝, 购买跳淘宝, 之后弹出特惠购
                [self openAlibcTradeWithId:Id];
            } else {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:alertTitle preferredStyle:UIAlertControllerStyleAlert];

                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
                [alertView addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 打开淘宝, 购买跳淘宝, 之后弹出特惠购
                    [self openAlibcTradeWithId:Id];
                }]];
                UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
                [tabbar presentViewController:alertView animated:NO completion:nil];
            }
        }
    }];
}

#pragma mark - /** 淘宝授权 */
+ (void)jipin_authTaobaoSuccess:(void (^)(BOOL isAuthTaobao))block
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
    // 为了同步关联的淘宝账号
    [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {
        NSString *specialId = [NSString stringWithFormat:@"%@", JPUSERINFO[@"relationId"]];
        if ([specialId isEqualToString:@""]) { // 没有关联
            block(NO);
            // 淘宝授权
            [self jipin_authTaobao];
        } else {
            block(YES);
        }
    }];

//    block(YES);
}

// 淘宝授权
+ (void)jipin_authTaobao
{
    CURRENTVC(currentVc);
    [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
    [[ALBBSDK sharedInstance] auth:currentVc successCallback:^(ALBBSession *session) {
        NSString *tip = [NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
        NSLog(@"%@", tip);
        TSLWebViewController *webVc = [[TSLWebViewController alloc] initWithURL:[NSURL URLWithString:@""] actionblock:^{
            [CZProgressHUD showProgressHUDWithText:@"授权成功"];
            [CZProgressHUD hideAfterDelay:1.5];
            // 为了同步关联的淘宝账号
            [CZUserInfoTool userInfoInformation:^(NSDictionary *param) {}];
        }];
        webVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [tabbar presentViewController:webVc animated:YES completion:nil];

        //拉起淘宝
        AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
        showParam.openType = AlibcOpenTypeAuto;
        showParam.backUrl = @"tbopen25267281://xx.xx.xx";
        showParam.isNeedPush = YES;
        showParam.nativeFailMode = AlibcNativeFailModeJumpH5;

        [CZProgressHUD hideAfterDelay:1.5];

        [[AlibcTradeSDK sharedInstance].tradeService
         openByUrl:[NSString stringWithFormat:@"https://oauth.m.taobao.com/authorize?response_type=code&client_id=25612235&redirect_uri=https://www.jipincheng.cn/qualityshop-api/api/taobao/returnUrl&state=%@&view=wap", JPTOKEN]
         identity:@"trade"
         webView:webVc.webView
         parentController:tabbar
         showParams:showParam
         taoKeParams:nil
         trackParam:nil
         tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
             NSLog(@"-----AlibcTradeSDK------");
             if(result.result == AlibcTradeResultTypeAddCard){
                 NSLog(@"交易成功");
             } else if(result.result == AlibcTradeResultTypeAddCard){
                 NSLog(@"加入购物车");
             }
         } tradeProcessFailedCallback:^(NSError * _Nullable error) {
             NSLog(@"----------退出交易流程----------");
         }];
    } failureCallback:^(ALBBSession *session, NSError *error) {
        NSString *tip=[NSString stringWithFormat:@"登录失败:%@",@""];
        NSLog(@"%@", tip);
    }];
}

// 0元购, 跳淘宝购买, 之后弹出特惠购, 获取备用金得到淘宝路径
+ (void)openAlibcTradeWithId:(NSString *)ID
{
    if (![JPUSERINFO[@"isNewUser"] isEqual:@(0)]) {
        [CZProgressHUD showProgressHUDWithText:@"您已不是新用户，无法参加0元购活动"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    };

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"allowanceGoodsId"] = ID;

    [GXNetTool PostNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/allowance/apply"] body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            [self jipin_jumpTaobaoWithUrlString:result[@"data"]];
            // 1.5s我进特惠购
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CURRENTVC(currentVc);
                [currentVc.navigationController popViewControllerAnimated:NO];

                CZSubFreePreferentialController *vc = [[CZSubFreePreferentialController alloc] init];
                UITabBarController *tabbar1 = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
                UINavigationController *nav1 = tabbar1.selectedViewController;
                UIViewController *currentVc1 = nav1.topViewController;
                [currentVc1.navigationController pushViewController:vc animated:YES];
            });
        } else {
            [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    } failure:^(NSError *error) {

    }];
}

// 根据url跳淘宝
+ (void)jipin_jumpTaobaoWithUrlString:(NSString *)urlString
{
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *naVc = tabbar.selectedViewController;
    UIViewController *toVC = naVc.topViewController;
    [CZOpenAlibcTrade openAlibcTradeWithUrlString:urlString parentController:toVC];
}

#pragma mark - 弹窗工具
+ (void)loadAlertView
{
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/getPopInfo"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *list = result[@"data"];
            if (list.count == 0) {
                [self pasteboardAlertViewRule];
                return;
            }

            // 判断数组中有几个
            if (list.count > 1) { // 两个以上
                alertList_ = [NSMutableArray array];
                for (int i = 0; i < list.count; i++) {
                    CZUpdataView *backView = [CZUpdataView buyingView];
                    backView.frame = [UIScreen mainScreen].bounds;
                    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                    backView.paramDic = list[i][@"data"];
                    [alertList_ addObject:backView];
                }

                [[UIApplication sharedApplication].keyWindow addSubview:alertList_[0]];

            } else { // 一个
                if ([list[0][@"type"] integerValue] == 1 || [list[0][@"type"] integerValue] == 0) { // 免单活动 一般活动
                    CZUpdataView *backView = [CZUpdataView buyingView];
                    backView.frame = [UIScreen mainScreen].bounds;
                    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                    [[UIApplication sharedApplication].keyWindow addSubview: backView];
                    backView.paramDic = list[0][@"data"];
                } else { // 完成首单
                    CZAlertView3Controller *vc = [[CZAlertView3Controller alloc] init];
                    vc.param = result[@"data"][0];
                    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    CURRENTVC(currentVc);
                    [currentVc presentViewController:vc animated:YES completion:nil];
                }
            }
        }
    } failure:^(NSError *error) {

    }];
}


#pragma mark - 复制搜索弹框规则
+ (void)pAlertViewRuleData
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"keyword"] = posteboard.string;
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/getInfoByKeyword"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            if ([result[@"data"][@"type"] isEqual: @(1)]) {
                CZGuessTypeTowView *view1 = [CZGuessTypeTowView createView];
                view1.dataDic = result[@"data"][@"data"];
                [[UIApplication sharedApplication].keyWindow addSubview:view1];
            } else if ([result[@"data"][@"type"] isEqual: @(2)]) {
                CZAlertView4Controller *vc = [[CZAlertView4Controller alloc] init];
                vc.param = result;
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                CURRENTVC(currentVc);
                [currentVc presentViewController:vc animated:YES completion:nil];
            } else {
                CZGuessTypeOneView *view1 = [CZGuessTypeOneView createView];
                view1.text = param[@"keyword"];
                [[UIApplication sharedApplication].keyWindow addSubview:view1];
            }
        }
    } failure:^(NSError *error) {// 结束刷新
    }];
}

+ (void)pasteboardAlertViewRule
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    NSString *string = posteboard.string;
    NSString *rrecordS = string;
    rrecordS = [rrecordS stringByReplacingOccurrencesOfString:@" " withString:@""];
    rrecordS = [rrecordS stringByReplacingOccurrencesOfString:@"　" withString:@""];

    if (string == nil || [rrecordS isEqualToString:@""]) {
        return;
    } else {
        if ([recordSearchTextArray containsObject:string]) {
            return;
        } else {
            [self pAlertViewRuleData];
            [recordSearchTextArray addObject:string];
        }
    }
}

#pragma mark -  弹出分享的弹框: 仅限分享淘宝商品
+ (void)jumpShareViewWithUrl:(NSString *)url Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(id)thumImage object:(id)object
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:nil];
        return;
    }

    CURRENTVC(currentVc);
    CZShareViewController *modalVc = [[CZShareViewController alloc] initWithBlock:^(NSInteger index) {
        NSLog(@"------%ld", (long)index);
        if (index == 0) {
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
                [CZProgressHUD showProgressHUDWithText:@"没有安装该平台!"];
                [CZProgressHUD hideAfterDelay:2];
                return;
            }
            [[CZUMConfigure shareConfigure] sharePlatform:UMSocialPlatformType_WechatSession controller:currentVc url:url Title:title subTitle:subTitle thumImage:thumImage shareType:1125 object:object];
        } else if (index == 1) {
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
                [CZProgressHUD showProgressHUDWithText:@"没有安装该平台!"];
                [CZProgressHUD hideAfterDelay:2];
                return;
            }
            [[CZUMConfigure shareConfigure] sharePlatform:UMSocialPlatformType_WechatTimeLine controller:currentVc url:url Title:title subTitle:subTitle thumImage:thumImage shareType:CZUMConfigureTypeWeb object:object];
        } else if (index == 2) {
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]) {
                [CZProgressHUD showProgressHUDWithText:@"没有安装该平台!"];
                [CZProgressHUD hideAfterDelay:2];
                return;
            }
            [[CZUMConfigure shareConfigure] sharePlatform:UMSocialPlatformType_Sina controller:currentVc url:url Title:title subTitle:subTitle thumImage:thumImage shareType:CZUMConfigureTypeWeb object:object];
        }

    }];
    [currentVc presentViewController:modalVc animated:YES completion:nil];
}

#pragma mark -   /** 判断界面是否该版本下的第一次加载 */
+ (BOOL)isFirstIntoWithIdentifier:(NSString *)identifier
{
    //获取当前的版本号
    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];

    //获取存储的版本号
    NSString *lastVersion = [CZSaveTool objectForKey:CZVERSION];

    //比较
    if (![curVersion isEqualToString:lastVersion]) {
        //新版本
        [CZSaveTool setObject:@"www" forKey:identifier];
    }
//    [CZSaveTool setObject:@"0rrrr" forKey:identifier];
    if ([[CZSaveTool objectForKey:identifier] isEqualToString:@"0"]) {
        // 老人
        return NO;
    } else {
        // 新人
        [CZSaveTool setObject:@"0" forKey:identifier];
        return YES;
    }
}

#pragma mark -  /** 友盟分享web*/
+ (void)JINPIN_UMShareWeb:(NSString *)url Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage Type:(UMSocialPlatformType)type
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
    // 设置网页
    UMShareWebpageObject *shareUrlObject = [UMShareWebpageObject shareObjectWithTitle:title descr:subTitle thumImage:thumImage];
    //设置网页地址
    shareUrlObject.webpageUrl = url;
    //调用分享接口
    messageObject.shareObject = shareUrlObject;
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:currentVc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            UMSocialShareResponse *dataResponse = data;
            NSLog(@"response data is %@", dataResponse.message);
        }
    }];
}

#pragma mark - /** 友盟分享纯图片*/
+ (void)JINPIN_UMShareImage:(id)thumImage Type:(UMSocialPlatformType)type
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

#pragma mark -  友盟分享纯文字
+ (void)JINPIN_UMShareText:(NSString *)text Type:(UMSocialPlatformType)type
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
    messageObject.text = text;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:currentVc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********", error);
        } else {
            NSLog(@"response data is %@", data);
        }
    }];
}

#pragma mark -  友盟分享小程序
+ (void)JINPIN_UMShareMiniPath:(NSString *)path Title:(NSString *)title subTitle:(NSString *)subTitle thumImage:(NSString *)thumImage userName:(NSString *)userName failureUrl:(NSString *)url
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
//    thumImage = [UIImage imageNamed:@"launchLogo.png"];
    NSData *currentImageData;
    if ([thumImage isKindOfClass:[UIImage class]]) {
        UIImage * newImage = (UIImage *)thumImage;
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

    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    UIViewController *currentVc = nav.topViewController;
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:subTitle thumImage:[UIImage imageWithData:currentImageData]];
    shareObject.webpageUrl = url;
    shareObject.userName = userName;
    shareObject.path = path;
    shareObject.hdImageData = currentImageData;
    shareObject.miniProgramType = UShareWXMiniProgramTypeRelease; // 可选体验版和开发板

    messageObject.shareObject = shareObject;

     //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:currentVc completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            UMSocialShareResponse *dataResponse = data;
            NSLog(@"response data is %@", dataResponse.message);
            //            [CZGetJIBITool getJiBiWitType:@(5)];
        }
    }];
}

#pragma mark -  调用系统分享多图片
+ (void)JINPIN_systemShareImages:(NSArray *)images success:(void (^)(BOOL completed))block
{
    NSArray *activityItems = images;

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];

    // 设定不想显示的平台和功能
    NSArray *excludeArray = @[
        UIActivityTypeAirDrop,
        UIActivityTypePrint,
        UIActivityTypePostToVimeo,
        UIActivityTypeMessage,
        UIActivityTypeMail,
    ];
    // 不需要分享的图标
    activityVC.excludedActivityTypes = excludeArray;

    [activityVC setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        NSLog(@"activityType: %@,\n completed: %d,\n returnedItems:%@,\n activityError:%@",activityType, completed, returnedItems, activityError);
        // 增加访问量
        !block ? : block(completed);
    }];
    CURRENTVC(currentVc)
    [currentVc presentViewController:activityVC animated: YES completion: nil];

}

#pragma mark - /** 保存图片到本地 */
+ (void)jipin_saveImage:(id)image
{
    [GXSaveImageToPhone saveBatchImage:image];
}

#pragma mark - /** 点击图片放大 */
+ (void)jipin_showZoomImage:(__kindof UIView * _Nonnull)obj
{
    [GXZoomImageView showZoomImage:obj];
}

#pragma mark - /** 判断未登录, 之后弹出登录页面 */
+ (void)jipin_jumpLogin
{
    if ([JPTOKEN length] <= 0) {
        CZLoginController *vc = [CZLoginController shareLoginController];
        UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
        [tabbar presentViewController:vc animated:NO completion:nil];
        return;
    }
}


@end
