//
//  CZTestSubController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZHotSaleDetailModel.h"

@interface CZTestSubController : UIViewController
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 详情数据模型 */
@property (nonatomic, strong) CZHotSaleDetailModel *model;
@end
