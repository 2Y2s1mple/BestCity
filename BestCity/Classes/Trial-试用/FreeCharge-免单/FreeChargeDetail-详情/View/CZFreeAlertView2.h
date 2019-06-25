//
//  CZFreeAlertView2.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeAlertView2 : UIView
+ (instancetype)freeAlertView:(void (^)(CZFreeAlertView2 *))rightBlock;
- (void)hide;
- (void)show;
/** <#注释#> */
@property (nonatomic, strong) NSString *point;
@end

NS_ASSUME_NONNULL_END
