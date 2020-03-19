//
//  CZIssueMomentsCell.h
//  BestCity
//
//  Created by JasonBourne on 2020/3/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZIssueMomentsModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface CZIssueMomentsCell : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, strong) CZIssueMomentsModel *param;
@end

NS_ASSUME_NONNULL_END
