//
//  CZSaveTool.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSaveTool.h"

@implementation CZSaveTool
+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
}


// 判断是不是第一次离开新人0元购
+ (BOOL)leaveOnceNew0yuan
{
    if ([[CZSaveTool objectForKey:@"leaveOnceNew0yuan"] isEqualToString:@"0"]) {
        return NO;
    } else {
        [CZSaveTool setObject:@"0" forKey:@"leaveOnceNew0yuan"];
        return YES;
    }
}

@end
