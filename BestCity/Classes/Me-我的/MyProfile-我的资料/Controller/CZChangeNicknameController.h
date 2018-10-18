//
//  CZChangeNicknameController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/2.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CZChangeNicknameControllerDelegate <NSObject>
@optional
- (void)updateUserInfo;

@end

@interface CZChangeNicknameController : UIViewController
/** 名字 */
@property (nonatomic, strong) NSString *name;
/** 代理 */
@property (nonatomic, assign) id<CZChangeNicknameControllerDelegate> delegate;
@end
