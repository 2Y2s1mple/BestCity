//
//  CZChoicenessCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/31.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZChoicenessCell.h"

@implementation CZChoicenessCell


+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"choiceCell";
    CZChoicenessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
