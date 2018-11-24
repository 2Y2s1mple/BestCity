//
//  CZMessageActivityCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMessageActivityCell.h"

@implementation CZMessageActivityCell
+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"messageActivityCell";
    CZMessageActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 10;
    frame.size.width -= 20;
    
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
