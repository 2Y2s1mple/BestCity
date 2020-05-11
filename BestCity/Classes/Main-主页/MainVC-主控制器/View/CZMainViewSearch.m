//
//  CZMainViewSearch.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainViewSearch.h"
#import "CZWechatTeacherView.h"
#import "CZMainHotSaleController.h"

@implementation CZMainViewSearch



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = SCR_WIDTH;
        self.userInteractionEnabled = YES;
       [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    UIButton *signInBtn = [[UIButton alloc] init];
    [signInBtn setImage:[UIImage imageNamed:@"Main-icon13"] forState:UIControlStateNormal];
    [signInBtn sizeToFit];
    signInBtn.width = 50;
    signInBtn.height = 36;
    [signInBtn addTarget:self action:@selector(pushSignInView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:signInBtn];
    
    UIButton *wechat = [[UIButton alloc] init];
    [wechat setImage:[UIImage imageNamed:@"Main-icon14"] forState:UIControlStateNormal];
    [wechat sizeToFit];
    wechat.x = SCR_WIDTH - 50;
    wechat.width = 50;
    wechat.height = 36;
    [wechat addTarget:self action:@selector(jumpAddWechatView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wechat];
    
    
    
    UIView *searchView = [[UIView alloc] init];
    [self addSubview:searchView];
    searchView.x = 50;
    searchView.width = SCR_WIDTH - 100;
    searchView.height = 36;
    searchView.layer.cornerRadius =  18;
    searchView.backgroundColor = UIColorFromRGB(0xF5F5F5);

    UILabel *title = [[UILabel alloc] init];
    title.text = @"搜商品名称或粘贴标题";
    title.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
    title.textColor = UIColorFromRGB(0x565252);
    [title sizeToFit];
    title.centerY = searchView.height / 2.0;
    title.centerX = searchView.width / 2;
    [searchView addSubview:title];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:@"search_search"];
    [image sizeToFit];
    image.x = title.x - 5 - image.width;
    image.centerY = searchView.height / 2.0;
    [searchView addSubview:image];
    
    self.height = searchView.height;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s", __func__);
    !self.block ? : self.block();
}

#pragma mark - 事件
// 跳转签到
- (void)pushSignInView
{
    // 任务中心
    [CZFreePushTool push_taskCenter];
}

// 添加微信导师
- (void)jumpAddWechatView
{
    CURRENTVC(currentVc);
    CZWechatTeacherView *vc = [[CZWechatTeacherView alloc] init];
    [currentVc presentViewController:vc animated:NO completion:nil];

    
//    CZMainHotSaleController *vc = [[CZMainHotSaleController alloc] init];
//    UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UINavigationController *nav = tabbar.selectedViewController;
//    [nav pushViewController:vc animated:YES];
    
}


@end
