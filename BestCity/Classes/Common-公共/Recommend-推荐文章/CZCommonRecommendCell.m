//
//  CZCommonRecommendCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/4/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZCommonRecommendCell.h"

@implementation CZCommonRecommendCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZCommonRecommendCell";
    CZCommonRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
