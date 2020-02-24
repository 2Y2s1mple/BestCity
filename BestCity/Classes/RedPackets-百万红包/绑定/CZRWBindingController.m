//
//  CZRWBindingController.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/24.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRWBindingController.h"
#import "GXNetTool.h"
#import "CZNavigationView.h"
#import "CZRWBindingView.h"

@interface CZRWBindingController ()
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;

@end

@implementation CZRWBindingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"绑定支付宝" rightBtnTitle:nil rightBtnAction:nil];
    navigationView.backgroundColor = CZGlobalWhiteBg;
    [self.view addSubview:navigationView];
    self.navigationView = navigationView;


    CZRWBindingView *topView = [CZRWBindingView RWBindingView];
    topView.y = CZGetY(navigationView);
    [self.view addSubview:topView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
