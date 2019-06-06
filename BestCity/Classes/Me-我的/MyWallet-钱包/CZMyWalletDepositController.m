//
//  CZMyWalletDepositController.m
//  BestCity
//
//  Created by JasonBourne on 2019/6/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMyWalletDepositController.h"
#import "CZNavigationView.h"

@interface CZMyWalletDepositController ()
/** 最上面的背景图 */
@property (nonatomic, weak) IBOutlet UIView *topView;
@end

@implementation CZMyWalletDepositController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalLightGray;
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"我要提现" rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];


    self.topView.layer.cornerRadius = 5;
    self.topView.layer.shadowColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1.0].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 4;

}


@end
