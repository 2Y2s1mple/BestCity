//
//  CZSystemMessageCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSystemMessageCell.h"

@implementation CZSystemMessageCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"systemMessageCell";
    CZSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setFrame:(CGRect)frame{
    frame.origin.x += 20;
    frame.size.width -= 40;
    
    frame.origin.y += 20;
    frame.size.height -= 20;
    
    [super setFrame:frame];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
