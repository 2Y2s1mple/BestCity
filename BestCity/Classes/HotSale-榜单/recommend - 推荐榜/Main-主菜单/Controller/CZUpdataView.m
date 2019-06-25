//
//  CZUpdataView.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUpdataView.h"
#import "CZCoinCenterController.h"

@interface CZUpdataView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *chengeContent;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *pointLabel;

/** 删除按钮 */
@property (nonatomic, weak) IBOutlet UIButton *delectBtn;
@end

@implementation CZUpdataView
+ (instancetype)updataView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0] ;
}

/** 去App Store */
- (IBAction)gotoUpdata
{
    //跳转到App Store
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app//id1450707933?mt=8"]];
}

/** 删除自己 */
- (IBAction)deleteView
{
    [self removeFromSuperview];
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


+ (instancetype)newUserRegistrationView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][1] ;
}

- (void)setUserPoint:(NSString *)userPoint
{
    _userPoint = userPoint;
    self.pointLabel.text = userPoint;
}

/** 新用户祖册 */
- (IBAction)newUserRegistrationAction
{
    [self removeFromSuperview];
    NSLog(@"------");
    CZCoinCenterController *vc = [[CZCoinCenterController alloc] init];
    
    UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    UINavigationController *nav = tabbar.selectedViewController;
    
    [nav pushViewController:vc animated:YES];
}

@end
