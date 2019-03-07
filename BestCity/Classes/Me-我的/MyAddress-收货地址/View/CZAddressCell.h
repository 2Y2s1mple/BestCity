//
//  CZAddressCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/6.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZAddressCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) CZAddressModel *addressModel;
@end

NS_ASSUME_NONNULL_END
