//
//  CZScrollADCell.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZScrollADCell.h"
#import "UIImageView+WebCache.h"


@interface CZScrollADCell ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label;
@end

@implementation CZScrollADCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setParamDic:(NSDictionary *)paramDic
{
    _paramDic = paramDic;
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:paramDic[@"avatar"]]];
    self.label.text = paramDic[@"content"];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
}


@end
