//
//  CZCommoditySubController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZRecommendDetailModel;
@class CZRecommendListModel;
@interface CZCommoditySubController : UIViewController
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 详情数据模型 */
@property (nonatomic, strong) CZRecommendDetailModel *model;
/** 列表里面有几行数据需要传过去 */
@property (nonatomic, strong) CZRecommendListModel *listModel;
@end
