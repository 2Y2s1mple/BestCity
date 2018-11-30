//
//  CZOpenAlibcTrade.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/27.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZOpenAlibcTrade : NSObject
+ (void)openAlibcTradeWithUrlString:(NSString *)urlStr parentController:(UIViewController *__nonnull)parentController;
@end

NS_ASSUME_NONNULL_END
