//
//  CZMyWalletCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZMyWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZMyWalletCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
@property (nonatomic, strong) CZMyWalletModel *model;
@end

NS_ASSUME_NONNULL_END
