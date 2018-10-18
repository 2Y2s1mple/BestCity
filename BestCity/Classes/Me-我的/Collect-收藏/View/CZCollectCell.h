//
//  CZCollectCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/6.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZCollectionModel.h"

@interface CZCollectCell : UITableViewCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
/** 收藏模型 */
@property (nonatomic, strong) CZCollectionModel *model;
@end
