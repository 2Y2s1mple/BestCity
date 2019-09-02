//
//  CZMePublishOneCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZETestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZMePublishOneCell : UITableViewCell
+ (instancetype)cellwithTableView1:(UITableView *)tableView;
+ (instancetype)cellwithTableView2:(UITableView *)tableView;
+ (instancetype)cellwithTableView3:(UITableView *)tableView;
+ (instancetype)cellwithTableView4:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) CZETestModel *model;
/** <#注释#> */
@property (nonatomic, strong) void (^action) (CZMePublishOneCell *cell);
@end

NS_ASSUME_NONNULL_END
