//
//  CZSettingCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZSettingCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** 左面的标题 */
@property (nonatomic, strong) NSString *title;
@end
