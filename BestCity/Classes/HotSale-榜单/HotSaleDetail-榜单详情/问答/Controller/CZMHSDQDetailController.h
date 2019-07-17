//
//  CZMHSDQDetailController.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
// 模型
#import "CZMHSDQuestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDQDetailController : UIViewController
@property (nonatomic, strong) CZMHSDQuestModel *model;
/** 商品ID */
@property (nonatomic, strong) NSString *ID;
@end

NS_ASSUME_NONNULL_END
