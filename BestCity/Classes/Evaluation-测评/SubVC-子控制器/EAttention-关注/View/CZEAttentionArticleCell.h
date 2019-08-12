//
//  CZEAttentionArticleCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
//数据模型
#import "CZEAttentionItemViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface CZEAttentionArticleCell : UITableViewCell <CZEAttentionItemViewModelProtocol>
+ (instancetype)cellwithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
