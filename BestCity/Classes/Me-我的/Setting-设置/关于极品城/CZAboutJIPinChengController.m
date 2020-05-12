//
//  CZAboutJIPinChengController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/12.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAboutJIPinChengController.h"
#import "CZNavigationView.h"

@interface CZAboutJIPinChengController ()

@end

@implementation CZAboutJIPinChengController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"关于极品城" rightBtnTitle:@"" rightBtnAction:^{
        
    } ];
    [self.view addSubview:navigationView];
    
    
}

@end
