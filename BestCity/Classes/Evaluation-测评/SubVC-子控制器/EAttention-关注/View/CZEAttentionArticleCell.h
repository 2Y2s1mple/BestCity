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
/** 关注按钮 */
@property (nonatomic, weak) IBOutlet UIButton *attentionBtn;
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** 刷新列表 */
@property (nonatomic, strong) void (^cellWithBlcok)(NSString *ID, BOOL isFollow);

- (void)attentionAction:(UIButton *)sender;
// 未关注样式
- (void)notAttentionBtnStyle:(UIButton *)sender;
// 已关注样式
- (void)attentionBtnStyle:(UIButton *)sender;
@end
NS_ASSUME_NONNULL_END
