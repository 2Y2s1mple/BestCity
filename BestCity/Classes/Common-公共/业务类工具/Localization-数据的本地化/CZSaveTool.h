//
//  CZSaveTool.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/16.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZSaveTool : NSObject
+ (id)objectForKey:(NSString *)defaultName;
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

// 判断是有是第一次离开新人0元购
+ (BOOL)leaveOnceNew0yuan;


@end
