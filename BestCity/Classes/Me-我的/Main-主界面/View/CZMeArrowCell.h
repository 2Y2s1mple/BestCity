//
//  CZMeArrowCell.h
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMeArrowCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *messageCountLabel;
/** shuju */
@property (nonatomic, strong) NSArray *list;
+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
