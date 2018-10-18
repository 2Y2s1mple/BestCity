//
//  CZMyPointDetailCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZPointDetailModel.h"

@interface CZMyPointDetailCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** 模型 */
@property (nonatomic, strong) CZPointDetailModel *model;
@end
