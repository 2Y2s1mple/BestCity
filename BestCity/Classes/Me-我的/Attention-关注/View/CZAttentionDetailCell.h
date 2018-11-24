//
//  CZAttentionDetailCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZAttentionDetailModel.h"

@interface CZAttentionDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *alphaBlackview;
+ (instancetype)cellWithTabelView:(UITableView *)tableView;

/** 高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 数据模型 */
@property (nonatomic, strong) CZAttentionDetailModel *model;
@end
