//
//  CZRedWithdrawalRecordCell.h
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZRedWithdrawalRecordCell : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *model;
@end

NS_ASSUME_NONNULL_END
