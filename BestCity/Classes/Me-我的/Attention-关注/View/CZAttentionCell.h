//
//  CZAttentionCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZAttentionsModel.h"

@interface CZAttentionCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 关注模型 */
@property (nonatomic, strong) CZAttentionsModel *model;
@end
