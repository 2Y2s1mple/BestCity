//
//  CZWelfareChangeCell.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/8.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZWelfareChangeCell.h"
#import "UIImageView+WebCache.h"

@interface CZWelfareChangeCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation CZWelfareChangeCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *ID = @"CZWelfareChangeCell";
    CZWelfareChangeCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model[@"img"]]];
    self.titleLabel.text = model[@"title"];


}

@end
