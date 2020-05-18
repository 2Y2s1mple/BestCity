//
//  CZCancellationAccountController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/15.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZCancellationAccountController.h"
#import "CZNavigationView.h"
#import "CZCancellationAccount1Controller.h"

@interface CZCancellationAccountController ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *mobileLabel;
@end

@implementation CZCancellationAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"注销账号" rightBtnTitle:@"" rightBtnAction:nil];
    [self.view addSubview:navigationView];
    
    NSString *mobile = JPUSERINFO[@"mobile"];
    NSString *string = [mobile stringByReplacingOccurrencesOfString:[mobile substringWithRange:NSMakeRange(3,4)] withString:@"****"];
    self.mobileLabel.text = string;
    
}

/** 注销 */
- (IBAction)CancellationAccount
{
    CZCancellationAccount1Controller *vc = [[CZCancellationAccount1Controller alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"---注销---");
}

/** 取消 */
- (IBAction)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
