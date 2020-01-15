//
//  CZBusinessTool.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/3.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZBusinessTool : NSObject
/** 跳淘宝购买 */
+ (void)buyBtnActionWithId:(NSString *)Id alertTitle:(NSString *)alertTitle;

/** 弹窗工具 */
+ (void)loadAlertView;

@end

NS_ASSUME_NONNULL_END
