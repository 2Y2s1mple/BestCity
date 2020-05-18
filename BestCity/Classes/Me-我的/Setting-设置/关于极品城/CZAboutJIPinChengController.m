//
//  CZAboutJIPinChengController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/12.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAboutJIPinChengController.h"
#import "CZNavigationView.h"
#import "CZCancellationAccountController.h"

@interface CZAboutJIPinChengController ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@end

@implementation CZAboutJIPinChengController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"关于极品城" rightBtnTitle:@"" rightBtnAction:^{
        
    } ];
    [self.view addSubview:navigationView];
    
    // 检查更新
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", infoDic[@"CFBundleShortVersionString"]];
}

- (IBAction)privacy
{
    [CZFreePushTool generalH5WithUrl:UserPrivacy_url title:@"隐私政策"];
    NSLog(@"《隐私政策》---------------");
}


- (IBAction)agreement
{
    [CZFreePushTool generalH5WithUrl:UserAgreement_url title:@"用户服务协议"];
    NSLog(@"《用户服务协议》---------------");
}

- (IBAction)cancellationAccount
{
    CZCancellationAccountController *vc = [[CZCancellationAccountController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"注销账号---------------");
}

@end
