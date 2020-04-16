//
//  CZAlertMainViewController.h
//  BestCity
//
//  Created by JsonBourne on 2020/4/16.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZAlertMainViewController : UIViewController
- (instancetype)initWithBlock:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
