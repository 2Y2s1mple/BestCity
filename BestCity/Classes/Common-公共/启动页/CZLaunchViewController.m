//
//  CZLaunchViewController.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/29.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZLaunchViewController.h"
#import "CZTabBarController.h"

@interface CZLaunchViewController ()
/** <#注释#> */
@property (nonatomic, strong) UIWindow *window;
@end

@implementation CZLaunchViewController

- (instancetype)initWithWidow:(UIWindow *)window
{
    self = [super init];
    if (self) {
        window.rootViewController = self;
        self.window = window;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CZTabBarController *tabbar = [[CZTabBarController alloc] init];
        tabbar.isFestival = YES;
        self.window.rootViewController = tabbar;
    });
}



@end
