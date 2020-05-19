//
//  CZJVerificationHandler.h
//  BestCity
//
//  Created by JsonBourne on 2020/5/18.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CZJVerificationHandler : NSObject
+ (instancetype)shareJVerificationHandler;

// 一键登录
- (void)JAuthorizationWithController:(UIViewController *)vc action:(void (^)(NSString *))action WexinLogin:(void (^)(void))wexinLogin otherMobileLogin:(void (^)(void))otherMobileLogin;

// 绑定微信
- (void)JAuthBindingWithController:(UIViewController *)vc action:(void (^)(NSString *))action OtherMobileLogin:(void (^)(void))otherMobileLogin;

// 判断
- (void)preLogin:(void (^)(BOOL success))isSuccess;
@end

NS_ASSUME_NONNULL_END
