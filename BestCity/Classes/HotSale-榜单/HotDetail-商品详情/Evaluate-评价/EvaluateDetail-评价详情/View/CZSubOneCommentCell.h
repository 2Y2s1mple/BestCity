//
//  CZSubOneCommentCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/11/22.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZSubOneCommentCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 头部数据 */
@property (nonatomic, strong) NSDictionary *contentDic;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
