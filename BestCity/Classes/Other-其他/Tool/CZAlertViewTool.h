//
//  CZAlertViewTool.h
//  BestCity
//
//  Created by JasonBourne on 2018/10/20.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CZActionBlock)(void);

@interface CZAlertViewTool : NSObject
+ (void)showSheetAlertAction:(CZActionBlock)block;
+ (void)showAlertWithTitle:(NSString *)title action:(CZActionBlock)block;
@end


