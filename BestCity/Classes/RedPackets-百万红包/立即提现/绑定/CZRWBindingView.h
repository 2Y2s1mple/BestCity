//
//  CZRWBindingView.h
//  BestCity
//
//  Created by JasonBourne on 2020/2/24.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZRWBindingView : UIView
+ (instancetype)RWBindingView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *model;

@end

NS_ASSUME_NONNULL_END
