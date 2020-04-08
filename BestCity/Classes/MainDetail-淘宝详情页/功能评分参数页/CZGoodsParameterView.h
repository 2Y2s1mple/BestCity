//
//  CZGoodsParameterView.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZGoodsParameterView : UIView
+ (instancetype)goodsParameterView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *detailModel;
@property (nonatomic, strong) NSString *titleName;
@end

NS_ASSUME_NONNULL_END
