//
//  CZTrialMainCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZTrialMainCell.h"

@implementation CZTrialMainCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *ID = @"CZTrialMainCell";
    CZTrialMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.size.height -= 5;
//    [super setFrame:frame];
//}

@end
