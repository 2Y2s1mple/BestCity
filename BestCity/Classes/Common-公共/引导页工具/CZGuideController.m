//
//  CZGuideController.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/26.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "CZGuideController.h"
#import "CZTabBarController.h"
@interface CZGuideController ()

@end

@implementation CZGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
    scrollerView.pagingEnabled = YES;
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollerView];
    
    
    NSInteger count = 3;
    for (int i = 0; i  <= count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.x = SCR_WIDTH * i;
        imageView.size = CGSizeMake(SCR_WIDTH, SCR_HEIGHT);
        [scrollerView addSubview:imageView];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i]];
    }
    scrollerView.contentSize = CGSizeMake(SCR_WIDTH * count, 0);
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.x = SCR_WIDTH * 2 + SCR_WIDTH / 2 - 75;
    btn.y = SCR_HEIGHT - 44 - 20;
    btn.width = 150;
    btn.height = 44;
    [scrollerView addSubview:btn];
    [btn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clicked
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[CZTabBarController alloc] init];
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
