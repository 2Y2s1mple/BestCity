//
//  CZWelfareChangeCell.h
//  BestCity
//
//  Created by JasonBourne on 2020/1/8.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZWelfareChangeCell : UITableViewCell
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *model;
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
