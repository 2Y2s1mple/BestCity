//
//  CZHotsaleSearchDetailController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/13.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//


#import "WMPageController.h"

@protocol hotsaleSearchDetailControllerDelegate <NSObject>
@optional
- (void)HotsaleSearchDetailController:(UIViewController *)vc isClear:(BOOL)clear;

@end

@interface CZHotsaleSearchDetailController : WMPageController
/** 保存的标题 */
@property (nonatomic, strong) NSString *textTitle;
/** 代理 */
@property (nonatomic, assign) id<hotsaleSearchDetailControllerDelegate> currentDelegate;
/** 类型 */
@property (nonatomic, strong) NSString *type;
@end
