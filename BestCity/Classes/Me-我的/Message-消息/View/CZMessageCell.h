//
//  CZMessageCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMessageCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *messages;
@end
