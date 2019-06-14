//
//  CZMyWalletWithdrawCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZWithdrawModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZMyWalletWithdrawCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** 数据 */
@property (nonatomic, strong) CZWithdrawModel *model;
@end

NS_ASSUME_NONNULL_END
