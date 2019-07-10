//
//  CZMHSDListNewCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZDiscoverDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDListNewCell : UITableViewCell
/** 数据模型 */
@property (nonatomic, strong) CZDiscoverDetailModel *model;
@end

NS_ASSUME_NONNULL_END
