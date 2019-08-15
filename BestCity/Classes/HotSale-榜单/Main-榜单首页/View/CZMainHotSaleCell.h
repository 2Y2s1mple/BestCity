//
//  CZMainHotSaleCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMainHotSaleCell : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *data;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *adDic;
@end

NS_ASSUME_NONNULL_END
