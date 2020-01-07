//
//  CZSubFreePreferentialCell1.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/6.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZSubFreeChargeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZSubFreePreferentialCell1 : UITableViewCell
/** 数据 */
@property (nonatomic, strong) CZSubFreeChargeModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
