//
//  CZIssueMomentsAlertView.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/18.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZIssueMomentsAlertView.h"

@interface CZIssueMomentsAlertView ()

@end

@implementation CZIssueMomentsAlertView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

/** <#注释#> */
- (IBAction)dismiss
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)openWechat{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }else {
        [CZProgressHUD showProgressHUDWithText:@"您的设备未安装微信APP"];
        [CZProgressHUD hideAfterDelay:1.5];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
