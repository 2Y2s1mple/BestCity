//
//  CZTrailTestCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/3/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZTrailTestCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *numbersLabel;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
