//
//  CZCreditorController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZCreditorControllerDelegate <NSObject>
@optional
- (void)updateData;
@end

@interface CZCreditorController : UIViewController
/** 代理 */
@property (nonatomic, assign) id<CZCreditorControllerDelegate> delegate;
@end
