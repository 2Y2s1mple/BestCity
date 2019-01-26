//
//  NSDictionary+CZExtension.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/27.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CZExtension)

- (NSDictionary *)deleteAllNullValue;

@end

NS_ASSUME_NONNULL_END
