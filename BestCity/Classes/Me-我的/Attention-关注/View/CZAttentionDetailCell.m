//
//  CZAttentionDetailCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/4.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZAttentionDetailCell.h"

@interface CZAttentionDetailCell ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation CZAttentionDetailCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"attentionDetailCell";
    CZAttentionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellHeight = CZGetY(self.bottomView);
    [self.alphaBlackview setRounderCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(15, 15) viewRect:CGRectMake(0, 0, SCR_WIDTH - 20, 60)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
