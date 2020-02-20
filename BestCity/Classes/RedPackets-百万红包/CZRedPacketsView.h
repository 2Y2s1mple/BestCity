//
//  CZRedPacketsView.h
//  BestCity
//
//  Created by JasonBourne on 2020/2/19.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZRedPacketsView : UIView
+ (instancetype)redPacketsView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *hongbaoView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *model;
@end

NS_ASSUME_NONNULL_END
