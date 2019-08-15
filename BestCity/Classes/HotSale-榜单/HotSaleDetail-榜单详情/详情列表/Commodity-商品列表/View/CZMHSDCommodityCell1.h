//
//  CZMHSDCommodityCell1.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDCommodityCell1 : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** 数据 */
@property (nonatomic, strong) NSArray *dataList;
/** 数据 */
@property (nonatomic, strong) NSDictionary *bkDataDic;
@property (nonatomic, strong) NSString *titleText;

@property (nonatomic, strong) NSString *ID;
@end

NS_ASSUME_NONNULL_END
