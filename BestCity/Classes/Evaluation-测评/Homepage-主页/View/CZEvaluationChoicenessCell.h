//
//  CZEvaluationChoicenessCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZEvaluationChoicenessModel.h"

@protocol CZEvaluationChoicenessCellDelegate <NSObject>
@optional
- (void)reloadCEvaluationChoicenessData;
@end

@interface CZEvaluationChoicenessCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 数据模型 */
@property (nonatomic, strong) CZEvaluationChoicenessModel *model;
/** 代理 */
@property (nonatomic, weak) id<CZEvaluationChoicenessCellDelegate> delegate;
@end
