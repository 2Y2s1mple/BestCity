//
//  CZScrollADCell1.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZScrollADCell1.h"
#import "UIImageView+WebCache.h"

@interface CZScrollADCell1 ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@end

@implementation CZScrollADCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setParamDic:(NSDictionary *)paramDic
{
    _paramDic = paramDic;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:paramDic[@"img"]]];
    self.label.text = paramDic[@"otherName"];
    self.label1.text = [NSString stringWithFormat:@"¥%@", paramDic[@"buyPrice"]];
    self.label2.text = [NSString stringWithFormat:@"¥%@", paramDic[@"otherPrice"]];
}

@end
