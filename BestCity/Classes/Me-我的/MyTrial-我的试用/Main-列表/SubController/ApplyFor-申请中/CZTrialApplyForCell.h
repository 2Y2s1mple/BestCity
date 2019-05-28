//
//  CZTrialApplyForCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTrialApplyForCell : UITableViewCell
/** 数据 */
@property (nonatomic, strong) NSDictionary *dicData;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
