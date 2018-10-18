//
//  CZMeCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMeCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *data;
@end
