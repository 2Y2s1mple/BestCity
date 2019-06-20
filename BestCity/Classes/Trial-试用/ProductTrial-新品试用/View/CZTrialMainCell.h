//
//  CZTrialMainCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZTrailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZTrialMainCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) CZTrailModel *trailModel;
@end

NS_ASSUME_NONNULL_END
