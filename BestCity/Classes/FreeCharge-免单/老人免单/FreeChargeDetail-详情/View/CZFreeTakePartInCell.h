//
//  CZFreeTakePartInCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/6/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeTakePartInCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
