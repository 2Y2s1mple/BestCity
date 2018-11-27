//
//  NSDictionary+CZExtension.m
//  BestCity
//
//  Created by JasonBourne on 2018/11/27.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "NSDictionary+CZExtension.h"

@implementation NSDictionary (CZExtension)
- (NSDictionary *)deleteAllNullValue
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:self];
    for (NSString *keyStr in mutableDic.allKeys) {
        if ([[mutableDic objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[mutableDic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}
@end
