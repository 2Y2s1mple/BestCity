//
//  CZAdministratorAccountController.m
//  BestCity
//
//  Created by JasonBourne on 2019/2/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZAdministratorAccountController.h"
#import "CZNavigationView.h"
@interface CZAdministratorAccountController ()

@end

@implementation CZAdministratorAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"账号管理" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
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
