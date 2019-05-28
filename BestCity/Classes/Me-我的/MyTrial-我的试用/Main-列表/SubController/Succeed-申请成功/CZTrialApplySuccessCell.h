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
typedef void(^cellBlock)(void);

@interface CZTrialApplySuccessCell : UITableViewCell
/** 数据 */
@property (nonatomic, strong) CZTrialApplySuccessModel *dicData;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 刷新cell */
@property (nonatomic, copy) cellBlock block;
/** 跳转到报告编辑器 */
@property (nonatomic, copy) void (^gotoEditorBlock) (NSString *);
@end

NS_ASSUME_NONNULL_END
