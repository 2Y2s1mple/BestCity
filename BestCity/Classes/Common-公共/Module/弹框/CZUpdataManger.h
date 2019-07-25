//
//  CZUpdataManger.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/22.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZUpdataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZUpdataManger : NSObject
+ (id <CZUpdataProtocol>)createUpdataManger;
+ (void)ShowUpdataViewWithNetworkService;
@end

NS_ASSUME_NONNULL_END
