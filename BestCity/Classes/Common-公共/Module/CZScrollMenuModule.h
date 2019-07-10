//
//  CZScrollMenuModule.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/5.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZScrollMenuModule : UIView
@property (nonatomic, strong) NSArray *titles;
/** <#注释#> */
@property (nonatomic, strong) UIColor *normalColor;
/** <#注释#> */
@property (nonatomic, strong) UIColor *selectColor;
/** <#注释#> */
@property (nonatomic, strong) void (^didSelectedTitle)(NSInteger) ;
@end

NS_ASSUME_NONNULL_END
