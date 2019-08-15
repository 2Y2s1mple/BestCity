//
//  CZEInventoryCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZETestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZEInventoryCell : UITableViewCell

+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) CZETestModel *model;
@end

NS_ASSUME_NONNULL_END
