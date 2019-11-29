//
//  CZTaobaoGoodsView.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTaobaoGoodsView : UIView
+ (instancetype)taobaoGoodsView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *model;

/** 记录xib的尺寸 */
@property (nonatomic, assign) CGFloat commodityH;
@end

NS_ASSUME_NONNULL_END
