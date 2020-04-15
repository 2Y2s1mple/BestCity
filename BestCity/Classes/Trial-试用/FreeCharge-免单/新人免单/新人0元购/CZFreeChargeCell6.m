//
//  CZFreeChargeCell6.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/2.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell6.h"
@interface CZFreeChargeCell6 ()
/** 津贴 */
@property (nonatomic, weak) IBOutlet UILabel *allowanceLabel;
@end

@implementation CZFreeChargeCell6

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeChargeCell6";
    CZFreeChargeCell6 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setModel:(CZSubFreeChargeModel *)model
{
    _model = model;
    self.allowanceLabel.text = [NSString stringWithFormat:@"%@", model.allowance];
    _model.cellHeight = 210;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
