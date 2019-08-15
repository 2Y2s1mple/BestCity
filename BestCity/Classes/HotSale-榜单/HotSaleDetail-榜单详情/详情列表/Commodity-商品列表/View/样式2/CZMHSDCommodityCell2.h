//
//  CZMHSDCommodityCell2.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDCommodityCell2 : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
