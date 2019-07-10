//
//  CZCommonRecommendCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/4/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZCommonRecommendCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 相关文章数据 */
@property (nonatomic, strong) NSDictionary *dataDic;
/** 百科 */
@property (nonatomic, strong) NSDictionary *articleDic;
@end

NS_ASSUME_NONNULL_END
