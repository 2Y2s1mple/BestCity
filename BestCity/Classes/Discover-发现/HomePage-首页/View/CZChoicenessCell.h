//
//  CZChoicenessCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZDiscoverDetailModel.h"
#import "CZAttentionDetailModel.h"

@interface CZChoicenessCell : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** 数据模型 */
@property (nonatomic, strong) CZDiscoverDetailModel *model;
/** 关注界面用到 */
@property (nonatomic, strong) CZAttentionDetailModel *attentionModel;
@end
