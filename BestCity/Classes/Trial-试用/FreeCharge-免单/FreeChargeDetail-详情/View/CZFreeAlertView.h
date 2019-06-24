//
//  CZFreeAlertView.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/24.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeAlertView : UIView
- (void)hide;
- (void)show;
+ (instancetype)freeAlertView:(void (^)(CZFreeAlertView *))rightBlock;
/** <#注释#> */
@property (nonatomic, strong) NSString *point;
@end

NS_ASSUME_NONNULL_END
