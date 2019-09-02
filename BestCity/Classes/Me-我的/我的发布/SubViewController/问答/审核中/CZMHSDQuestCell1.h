//
//  CZMHSDQuestCell1.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZMHSDQuestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDQuestCell1 : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
@property (nonatomic, strong) CZMHSDQuestModel *model;

@end

NS_ASSUME_NONNULL_END
