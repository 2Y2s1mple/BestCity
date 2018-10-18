//
//  CZLoginController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CZLoginControllerDelegate <NSObject>
@optional
- (void)setUpUserInfo;

@end

@interface CZLoginController : UIViewController
/** 代理方法 */
@property (nonatomic, assign) id<CZLoginControllerDelegate> delegate;
@end
