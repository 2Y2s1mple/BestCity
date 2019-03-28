//
//  CZTrialReportMainCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZTrailReportModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZTrialReportMainCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) CZTrailReportModel *trailReportModel;
@end

NS_ASSUME_NONNULL_END
