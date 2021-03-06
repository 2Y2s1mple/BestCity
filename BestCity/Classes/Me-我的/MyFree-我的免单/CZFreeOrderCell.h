//
//  CZFreeOrderCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFreeOrderCell : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@end

NS_ASSUME_NONNULL_END
