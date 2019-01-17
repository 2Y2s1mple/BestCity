//
//  CZHisSearchCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZHisSearchCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 历史数据 */
@property (nonatomic, strong) NSString *historyData;
@end

NS_ASSUME_NONNULL_END
