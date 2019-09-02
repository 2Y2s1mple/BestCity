//
//  CZMeArrowCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMeArrowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *messageCountLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *lineView;
/** shuju */
@property (nonatomic, strong) NSDictionary *dataSource;
+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
