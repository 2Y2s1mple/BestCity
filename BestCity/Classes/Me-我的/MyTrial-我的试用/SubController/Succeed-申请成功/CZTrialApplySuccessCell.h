//
//  CZTrialApplySuccessCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CZTrialApplySuccessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZTrialApplySuccessCell : UITableViewCell
/** 数据 */
@property (nonatomic, strong) CZTrialApplySuccessModel *dicData;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
