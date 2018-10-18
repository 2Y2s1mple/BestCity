//
//  CZMeArrowCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/1.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMeArrowCell.h"

@interface CZMeArrowCell ()

@end

@implementation CZMeArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"meArrowCell";
    CZMeArrowCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZMeArrowCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    self.icon.image = [UIImage imageNamed:dataSource[@"icon"]];
    self.title.text = dataSource[@"title"];
}
@end
