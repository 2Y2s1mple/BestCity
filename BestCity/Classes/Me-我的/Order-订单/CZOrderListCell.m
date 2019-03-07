//
//  CZOrderListCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZOrderListCell.h"
@interface CZOrderListCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *affirmBtn;
/** 实付 */
@property (nonatomic, weak) IBOutlet UILabel *realPayLabel;
@end

@implementation CZOrderListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"orderListCell";
    CZOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.realPayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.affirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 5;
    frame.origin.x = 5;
    frame.size.width -= 10;
    return [super setFrame:frame];  
}


@end
