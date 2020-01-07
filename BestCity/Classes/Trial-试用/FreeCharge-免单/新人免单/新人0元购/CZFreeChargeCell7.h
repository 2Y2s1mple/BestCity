//
//  CZFreeChargeCell7.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/3.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZSubFreeChargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeCell7 : UITableViewCell
@property (nonatomic, strong) CZSubFreeChargeModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
