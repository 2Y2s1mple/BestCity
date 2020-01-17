//
//  CZUpdataView.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZUpdataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZUpdataView : UIView <CZUpdataProtocol>
/** 抢购 */
+ (instancetype)buyingView;
/** 抢购数据 */
@property (nonatomic, strong) NSDictionary *paramDic;
@end

NS_ASSUME_NONNULL_END
