//
//  CZFreeChargeCell5.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/2.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZFreeChargeCell5.h"
@interface CZFreeChargeCell5 ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *btnLabal;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *btnImage;
@end

@implementation CZFreeChargeCell5

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CZFreeChargeCell5";
    CZFreeChargeCell5 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.origin.x = 10;
    rect.size.width -= 20;
    [super setFrame:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CZSubFreeChargeModel *)model
{
    _model = model;
    if ([model.typeNumber isEqual: @(101)]) {
        self.btnLabal.text = @"点击收起";
        self.btnImage.image = [UIImage imageNamed:@"list-right-5"];

    }
    if ([model.typeNumber isEqual: @(100)]) {
        self.btnLabal.text = @"展开更多";
        self.btnImage.image = [UIImage imageNamed:@"list-right-4"];

    }


    _model.cellHeight = 55;
}

@end
