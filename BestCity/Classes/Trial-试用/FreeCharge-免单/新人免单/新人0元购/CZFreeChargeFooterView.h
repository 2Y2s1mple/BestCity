//
//  CZFreeChargeFooterView.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeFooterView : UIView
+ (instancetype)freeChargeFooterView;
/** <#注释#> */
@property (nonatomic, assign) BOOL isUpArrow;
/** <#注释#> */
@property (nonatomic, strong) void (^block)(void);
@end

NS_ASSUME_NONNULL_END
