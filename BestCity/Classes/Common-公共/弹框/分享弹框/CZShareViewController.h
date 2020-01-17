//
//  CZShareViewController.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/16.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZShareViewController : UIViewController
- (instancetype)initWithBlock:(void (^)(NSInteger index))block;
@end

NS_ASSUME_NONNULL_END
