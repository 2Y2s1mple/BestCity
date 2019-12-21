//
//  CZFreePushTool.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreePushTool : NSObject
+ (void)bannerPushToVC:(NSDictionary *)param;
+ (void)categoryPushToVC:(NSDictionary *)param;
@end

NS_ASSUME_NONNULL_END
