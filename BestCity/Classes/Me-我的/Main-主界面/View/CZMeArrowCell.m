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
+ (instancetype)cellWithTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"meArrowCell";
    CZMeArrowCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CZMeArrowCell class]) owner:nil options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 40, 60) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer  alloc]  init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    } else if (indexPath.row == 4) {
        UIBezierPath *bezierPath = [UIBezierPath  bezierPathWithRoundedRect:CGRectMake(0, 0, SCR_WIDTH - 40, 60) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *mask = [[CAShapeLayer alloc] init];
        mask.frame = cell.bounds;
        mask.path = bezierPath.CGPath;
        cell.layer.mask = mask;
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
