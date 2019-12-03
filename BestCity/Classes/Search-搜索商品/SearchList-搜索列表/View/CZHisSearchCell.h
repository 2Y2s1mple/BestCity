//
//  CZHisSearchCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/1/14.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^deleteBtnBlock)(void);

@interface CZHisSearchCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView deleteBtnBlock:(deleteBtnBlock)block;
/** 历史数据 */
@property (nonatomic, strong) NSDictionary *historyData;
/** 单条数据的ID */
@property (nonatomic, strong) NSString *dataId;
/** <#注释#> */
@property (nonatomic, copy) deleteBtnBlock deleteBlock;
@end

NS_ASSUME_NONNULL_END
