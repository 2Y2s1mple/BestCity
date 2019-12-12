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
//            [mutableDic setObject:@"" forKey:keyStr];
            [mutableDic removeObjectForKey:keyStr];
        } else {
            [mutableDic setObject:[mutableDic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

- (NSDictionary *)changeAllNnmberValue
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:[self deleteAllNullValue]];
    for (NSString *keyStr in mutableDic.allKeys) {
        id value = [mutableDic objectForKey:keyStr];
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            // 小数位最多位数
            numberFormatter.maximumFractionDigits = 2;
            numberFormatter.minimumFractionDigits = 2;

            NSString *formattedNumberString = [numberFormatter stringFromNumber:value];
            [mutableDic setObject:[NSString stringWithFormat:@"%@", formattedNumberString] forKey:keyStr];
        } else {
            [mutableDic setObject:value forKey:keyStr];
        }
    }
    return mutableDic;
}
@end
