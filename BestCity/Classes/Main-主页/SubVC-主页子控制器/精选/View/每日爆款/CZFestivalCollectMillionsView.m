//
//  CZFestivalCollectMillionsView.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/7.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectMillionsView.h"

@interface CZFestivalCollectMillionsView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel1;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel2;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel3;
@end

@implementation CZFestivalCollectMillionsView
+ (instancetype)festivalCollectMillionsView
{
    CZFestivalCollectMillionsView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    self.priceLabel3.font =  self.priceLabel2.font = self.priceLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];;

}
@end
