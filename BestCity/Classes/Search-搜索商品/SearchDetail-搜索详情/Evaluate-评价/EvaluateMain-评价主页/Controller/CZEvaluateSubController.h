//
//  CZEvaluateSubController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CZEvaluateSubController : UIViewController
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 商品ID */
@property (nonatomic, strong) NSString *targetId;
/** 类型: 1商品，2评测, 3发现，4试用 */
@property (nonatomic, strong) NSString *type;
@end
