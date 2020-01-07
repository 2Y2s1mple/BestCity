//
//  CZMeArrowCell2.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/7.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMeArrowCell2.h"
@interface CZMeArrowCell2 ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation CZMeArrowCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.iconImage.image = [UIImage imageNamed:dataDic[@"icon"]];
    self.titleLabel.text = dataDic[@"title"];
    
}
@end
