//
//  CZCommodityView.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/26.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZRecommendDetailModel.h"

@interface CZCommodityView : UIView
/** 记录xib的尺寸 */
@property (nonatomic, assign) CGFloat commodityH;
/** 数据 */
@property (nonatomic, strong) CZRecommendDetailModel *model;
@end
