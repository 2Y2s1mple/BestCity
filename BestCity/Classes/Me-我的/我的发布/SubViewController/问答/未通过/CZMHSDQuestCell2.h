//
//  CZMHSDQuestCell2.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/26.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZMHSDQuestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDQuestCell2 : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
@property (nonatomic, strong) CZMHSDQuestModel *model;
/** <#注释#> */
@property (nonatomic, strong) void (^action) (CZMHSDQuestCell2 *cell);
@end

NS_ASSUME_NONNULL_END
