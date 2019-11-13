//
//  CZGuideTool.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZGuideTool.h"
#import "CZSaveTool.h"
#import "CZTabBarController.h"
#define CZVERSION @"CZVersion"
#import "GXNetTool.h"
#import "CZNoviceGuidanceView.h"
#import "CZUpdataManger.h"


BOOL oldUser;
@implementation CZGuideTool
+ (void)newpPeopleGuide
{
    //获取当前的版本号

    NSString *curVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    //获取存储的版本号
    NSString *lastVersion = [CZSaveTool objectForKey:CZVERSION];
    
    //比较
    if ([curVersion isEqualToString:lastVersion]) {
        oldUser = YES;
        // 显示版本更新
        [CZUpdataManger ShowUpdataViewWithNetworkService];
    } else {
        oldUser = NO;
//        // 新人引导
//        CZNoviceGuidanceView *guide = [[CZNoviceGuidanceView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        guide.backgroundColor = [UIColor clearColor];
//        [[UIApplication sharedApplication].keyWindow addSubview: guide];
//        [CZSaveTool setObject:curVersion forKey:CZVERSION];

        // 显示版本更新
        [CZUpdataManger ShowUpdataViewWithNetworkService];
    }
}

@end
