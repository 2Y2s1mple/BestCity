//
//  CZLaunchViewController.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/29.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZLaunchViewController.h"
#import "CZTabBarController.h"
#import "GXNetTool.h"

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
    [self isOpenDouble11];
}

- (void)isOpenDouble11
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //获取详情数据
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/open11"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        CZTabBarController *tabbar = [[CZTabBarController alloc] init];
        if ([result[@"code"] isEqual:@(0)]) {
            tabbar.isFestival = [result[@"data"] isEqualToString:@"1"];
        } else {
            tabbar.isFestival = NO;
        }
        isFestival = tabbar.isFestival;
        self.window.rootViewController = tabbar;
    } failure:^(NSError *error) {
        CZTabBarController *tabbar = [[CZTabBarController alloc] init];
        tabbar.isFestival = NO;
        isFestival = tabbar.isFestival;
        self.window.rootViewController = tabbar;
    }];
}




@end
