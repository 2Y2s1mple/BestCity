//
//  CZIssueMomentsCell.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZIssueMomentsCell.h"
#import "CZIssueMomentsShareView.h"

@implementation CZIssueMomentsCell
+ (instancetype)cellwithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZIssueMomentsCell";
    CZIssueMomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;

    


    
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
