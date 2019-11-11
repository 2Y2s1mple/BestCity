//
//  CZTableViewCell1.h
//  BestCity
//
//  Created by JasonBourne on 2019/11/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTableViewCell1 : UITableViewCell
+ (instancetype)cellwithTableView:(UITableView *)tableView;
@property (nonatomic, strong) NSDictionary *model;
@end

NS_ASSUME_NONNULL_END
