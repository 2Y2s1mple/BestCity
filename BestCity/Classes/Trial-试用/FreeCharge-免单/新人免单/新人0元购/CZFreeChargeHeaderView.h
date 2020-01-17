//
//  CZFreeChargeHeaderView.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeHeaderView : UIView
/** 官方微信 */
@property (nonatomic, strong) NSString *officialWeChat;
+ (instancetype)freeChargeHeaderView;
@end

NS_ASSUME_NONNULL_END
