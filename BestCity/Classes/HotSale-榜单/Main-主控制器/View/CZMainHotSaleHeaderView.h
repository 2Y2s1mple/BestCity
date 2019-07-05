//
//  CZMainHotSaleHeaderView.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMainHotSaleHeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame action:(void (^)(void))action;
- (instancetype)initWithFrame:(CGRect)frame pushAction:(void (^)(void))action;
@end

NS_ASSUME_NONNULL_END
