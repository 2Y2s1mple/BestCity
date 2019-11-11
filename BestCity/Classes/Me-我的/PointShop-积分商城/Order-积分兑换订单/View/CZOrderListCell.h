//
//  CZOrderListCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZOrderListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) CZOrderModel *model;
@end

NS_ASSUME_NONNULL_END
