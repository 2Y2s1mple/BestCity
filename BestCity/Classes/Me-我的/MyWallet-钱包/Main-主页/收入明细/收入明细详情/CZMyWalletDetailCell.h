//
//  CZMyWalletDetailCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CZMyWalletDetailCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
@property (nonatomic, strong) NSDictionary *model;
@end

NS_ASSUME_NONNULL_END
