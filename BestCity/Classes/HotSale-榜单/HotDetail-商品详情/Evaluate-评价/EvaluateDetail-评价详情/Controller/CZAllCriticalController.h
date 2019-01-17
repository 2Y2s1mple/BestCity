//
//  CZAllCriticalController.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/30.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZEvaluateModel;
@interface CZAllCriticalController : UIViewController
/** 评论数据 */
@property (nonatomic, strong) NSMutableArray *evaluateArr;
/** 评论总数 */
@property (nonatomic, strong) NSNumber *totalCommentCount;
/** 商品ID */
@property (nonatomic, strong) NSString *goodsId;
/** 类型: 1商品，2评测, 3发现，4试用 */
@property (nonatomic, strong) NSString *type;
@end
