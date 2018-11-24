//
//  CZSystemMessageCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZSystemMessageModel.h"

@interface CZSystemMessageCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** 数据模型 */
@property (nonatomic, strong) CZSystemMessageModel *model;
@end
