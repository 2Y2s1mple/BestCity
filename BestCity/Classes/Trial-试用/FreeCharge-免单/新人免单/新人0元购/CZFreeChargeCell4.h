//
//  CZFreeChargeCell4.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/15.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZSubFreeChargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeCell4 : UITableViewCell
/** 数据 */
@property (nonatomic, strong) CZSubFreeChargeModel *model;
/** <#注释#> */
//@property (nonatomic, strong) NSDictionary *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
