//
//  CZNavigationViewFactory.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZNavigationViewFactory : NSObject
+ (CZNavigationView *)navigationViewWithTitle:(NSString *)title rightBtn:(id)subTitle rightBtnAction:(void (^)(void))sender;
@end

NS_ASSUME_NONNULL_END
