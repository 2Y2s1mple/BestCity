//
//  CZTrialApplySuccessController.h
//  BestCity
//
//  Created by JasonBourne on 2019/4/2.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTrialApplySuccessController : UIViewController
/** 表单 */
@property (nonatomic, strong) UITableView *tableView;

- (void)reloadNewTrailDataSorce;
@end

NS_ASSUME_NONNULL_END
