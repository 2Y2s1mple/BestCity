//
//  CZMHSDCommodityCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDCommodityCell : UITableViewCell
/** 数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
/** 位置 */
@property (nonatomic, assign) NSInteger indexNumber;
@end

NS_ASSUME_NONNULL_END
