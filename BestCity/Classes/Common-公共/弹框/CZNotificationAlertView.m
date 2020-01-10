//
//  CZNotificationAlertView.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/23.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZNotificationAlertView.h"
#import <UserNotifications/UserNotifications.h>
#import "GXNetTool.h"
#import "CZUpdataView.h"
#import "CZAlertTool.h"
#import "CZAlertView3Controller.h"
UIKIT_EXTERN BOOL oldUser;

@implementation CZNotificationAlertView
/** 退出 */
- (IBAction)delete
{
    [self loadUserAlert];
    [self removeFromSuperview];
}

- (IBAction)setNotification:(id)sender {
    NSLog(@"-----");
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    });
    [self loadUserAlert];
    [self removeFromSuperview];
}

+ (instancetype)notificationAlertView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

-(void) checkCurrentNotificationStatus
{
    if (oldUser) {
        [self loadUserAlert];
        return;
    }

    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    if (@available(iOS 10 , *)) {
         [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                // 没权限
                NSLog(@"没权限");
               dispatch_async(dispatch_get_main_queue(), ^{
                   [[UIApplication sharedApplication].keyWindow addSubview:self];
               });
            } else {
                NSLog(@"有权限");
                [self loadUserAlert];
            }

        }];
    } else if (@available(iOS 8 , *)) {
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];

        if (setting.types == UIUserNotificationTypeNone) {
            // 没权限
            NSLog(@"没权限");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow addSubview:self];
            });
        } else {
            NSLog(@"有权限");
            [self loadUserAlert];
        }
    } else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type == UIUserNotificationTypeNone) {
            // 没权限
            NSLog(@"没权限");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow addSubview:self];
            });
        } else {
            NSLog(@"有权限");
            [self loadUserAlert];
        }
    }
}

- (void)loadUserAlert
{
    //获取数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v3/getPopInfo"] body:nil header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
            NSArray *list = result[@"data"];
            if (list.count == 0) {
                [CZAlertTool alertRule];
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
                    vc.param = result[@"data"];
                    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    CURRENTVC(currentVc);
                    [currentVc presentViewController:vc animated:YES completion:nil];
                }
            }
        }
    } failure:^(NSError *error) {

    }];
}


@end
