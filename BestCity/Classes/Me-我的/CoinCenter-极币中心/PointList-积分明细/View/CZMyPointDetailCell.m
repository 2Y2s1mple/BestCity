//
//  CZMyPointDetailCell.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/3.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZMyPointDetailCell.h"

@interface CZMyPointDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
@implementation CZMyPointDetailCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"myPointDetailCell";
    CZMyPointDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 10;
    frame.size.width -= 2 * frame.origin.x;
    [super setFrame:frame];
}

- (void)setModel:(CZPointDetailModel *)model
{
    _model = model;
    self.titleName.text = model.remark;
    self.timeLabel.text = model.createTime;
    NSString *point = [NSString stringWithFormat:@"%@", model.point];
    point = [point substringToIndex:1];
    if ([point isEqualToString:@"-"]) {
        self.amountLabel.text = model.point;
    } else {
        self.amountLabel.text = [NSString stringWithFormat:@"+%@", model.point];
    }
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
