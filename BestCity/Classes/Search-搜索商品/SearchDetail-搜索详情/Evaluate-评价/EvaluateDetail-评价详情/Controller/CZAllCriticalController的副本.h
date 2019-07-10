//
//  CZAllCriticalController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZRecommendDetailModel.h"

@interface CZAllCriticalController : UIViewController
/** 评论数据 */
@property (nonatomic, strong) NSMutableArray *evaluateArr;
/** 详情数据模型 */
@property (nonatomic, strong) CZRecommendDetailModel *model;
/** 评论总数 */
@property (nonatomic, strong) NSNumber *totalCommentCount;
@end
