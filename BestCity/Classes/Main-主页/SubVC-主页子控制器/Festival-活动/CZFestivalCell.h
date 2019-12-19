//
//  CZFestivalCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/10/30.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFestivalCell : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dataDic1;
@end

NS_ASSUME_NONNULL_END
