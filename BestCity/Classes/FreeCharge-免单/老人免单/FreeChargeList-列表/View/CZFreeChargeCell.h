//
//  CZFreeChargeCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/19.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZFreeChargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) CZFreeChargeModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
