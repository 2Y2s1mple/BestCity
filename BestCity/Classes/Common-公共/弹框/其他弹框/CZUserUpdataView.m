//
//  CZUserUpdataView.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/23.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUserUpdataView.h"
#import "CZNotificationAlertView.h"

@interface CZUserUpdataView ()
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UILabel *chengeContent;
/** 删除按钮 */
@property (nonatomic, weak) IBOutlet UIButton *delectBtn;
@end

@implementation CZUserUpdataView
+ (instancetype)userUpdataView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];;
}

- (void)setVersionMessage:(NSDictionary *)versionMessage
{
    _versionMessage = versionMessage;
    self.versionLabel.text = versionMessage[@"versionName"];
    self.chengeContent.text = versionMessage[@"content"];
    if ([versionMessage[@"needUpdate"] integerValue] == 1) {
        self.delectBtn.hidden = YES;
    }
}

/** 去App Store */
- (IBAction)gotoUpdata
{
    // 推送弹框
    CZNotificationAlertView *NotiView = [CZNotificationAlertView notificationAlertView];
    [NotiView checkCurrentNotificationStatus];
    //跳转到App Store
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app//id1450707933?mt=8"]];
}

/** 删除自己 */
- (IBAction)deleteView
{
    // 推送弹框
    CZNotificationAlertView *NotiView = [CZNotificationAlertView notificationAlertView];
    [NotiView checkCurrentNotificationStatus];
    [self removeFromSuperview];
}

@end
