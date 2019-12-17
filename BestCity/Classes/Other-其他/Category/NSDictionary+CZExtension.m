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


- (NSDictionary *)changeAllValueWithString
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:[self deleteAllNullValue]];
    for (NSString *keyStr in mutableDic.allKeys) {
        id value = [mutableDic objectForKey:keyStr];
        if (![value isKindOfClass:[NSString class]]) {
            NSString *stringValue = [NSString stringWithFormat:@"%@", value];
            NSArray *arr = [stringValue componentsSeparatedByString:@"."];
            if (arr.count > 1){
                NSString *str = arr[1];
                if (str.length <= 2) {
                    [mutableDic setObject:stringValue forKey:keyStr];
                } else {
                    NSString *currentValue = [NSString stringWithFormat:@"%@.%@", arr[0], [str substringToIndex:2]];
                    [mutableDic setObject:currentValue forKey:keyStr];
                }
            } else {
                [mutableDic setObject:stringValue forKey:keyStr];
            }
        } else {
            [mutableDic setObject:value forKey:keyStr];
        }
    }
    return mutableDic;
}
@end
