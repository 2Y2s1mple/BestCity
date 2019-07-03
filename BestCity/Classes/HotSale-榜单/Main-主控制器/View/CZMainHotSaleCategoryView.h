//
//  CZMainHotSaleCategoryView.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/3.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
// 模型
#import "CZHotTitleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZMainHotSaleCategoryView : UIView
@property (nonatomic, strong) NSArray <CZHotTitleModel *> *dataSource;
@end

NS_ASSUME_NONNULL_END
