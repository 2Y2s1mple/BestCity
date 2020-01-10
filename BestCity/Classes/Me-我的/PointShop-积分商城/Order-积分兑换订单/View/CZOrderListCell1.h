//
//  CZOrderListCell1.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/10.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZOrderListCell1 : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) CZOrderModel *model;
@end

NS_ASSUME_NONNULL_END
