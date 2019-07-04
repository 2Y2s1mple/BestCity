//
//  CZMainHotSaleCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/7/4.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainHotSaleCell.h"
#import "UIImageView+WebCache.h"

@interface CZMainHotSaleCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *digImageView;
/** 标题 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation CZMainHotSaleCell

- (void)setData:(NSDictionary *)data
{
    _data = data;
    [self.digImageView sd_setImageWithURL:[NSURL URLWithString:data[@"topImg"]]];
    self.titleLabel.text = data[@"topTitle"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 21];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
