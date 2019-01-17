//
//  CZTestSubController.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/27.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZTestDetailModel.h"

@interface CZTestSubController : UIViewController
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollerView;
/** 详情数据模型 */
@property (nonatomic, strong) CZTestDetailModel *model;
/** 文章的类型: 1商品，2评测, 3发现，4试用 */
@property (nonatomic, strong) NSString *detailTtype;
/** 判断关注的状态 */
@property (nonatomic, assign) BOOL isAttentionUser;
@end
