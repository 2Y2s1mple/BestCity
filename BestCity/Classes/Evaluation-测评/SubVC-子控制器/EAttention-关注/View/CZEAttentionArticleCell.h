//
//  CZEAttentionArticleCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZEvaluationProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@interface CZEAttentionArticleCell : UITableViewCell <CZEvaluationProtocol>
+ (instancetype)cellwithTableView:(UITableView *)tableView;

- (void)attentionAction:(UIButton *)sender;
// 未关注样式
- (void)notAttentionBtnStyle:(UIButton *)sender;
// 已关注样式
- (void)attentionBtnStyle:(UIButton *)sender;
@end
NS_ASSUME_NONNULL_END
