//
//  CZRecommendDetailController.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/8.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZRecommendListModel.h"

@interface CZRecommendDetailController : UIViewController
/** 商品ID */
/** 列表传过来的数据模型 */
//@property (nonatomic, strong) CZRecommendListModel *model;
@property (nonatomic, strong) NSString *goodsId;
@end

