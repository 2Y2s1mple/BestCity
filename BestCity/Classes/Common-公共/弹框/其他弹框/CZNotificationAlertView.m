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
#import "CZAlertView3Controller.h"

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

- (void)checkCurrentNotificationStatus
{
    if (![CZJIPINSynthesisTool jipin_isNewVersion]) {
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
    [CZJIPINSynthesisTool jipin_loadAlertView];
}


@end
