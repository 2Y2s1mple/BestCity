//
//  CZFreeChargeCell6.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/2.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZSubFreeChargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeChargeCell6 : UITableViewCell

@property (nonatomic, strong) CZSubFreeChargeModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
