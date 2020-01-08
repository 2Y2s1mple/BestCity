//
//  CZFestivalCollectMillionsView.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/7.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectMillionsView.h"
#import "UIImageView+WebCache.h"

@interface CZFestivalCollectMillionsView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel1;
@property (nonatomic, weak) IBOutlet UILabel *subpriceLabel1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel2;
@property (nonatomic, weak) IBOutlet UILabel *subpriceLabel2;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel3;
@property (nonatomic, weak) IBOutlet UILabel *subpriceLabel3;
@property (nonatomic, weak) IBOutlet UIImageView *imageView3;
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

- (void)setAllowanceGoodsList:(NSArray *)allowanceGoodsList
{
    _allowanceGoodsList = allowanceGoodsList;
    for (int i = 0; i < allowanceGoodsList.count; i++) {
            NSDictionary *imageDic = [allowanceGoodsList[i] changeAllValueWithString];
            NSString *image = imageDic[@"img"];
            NSString *text = [NSString stringWithFormat:@"¥%@", imageDic[@"buyPrice"]];
        NSString *subText = [NSString stringWithFormat:@"减%@元", imageDic[@"totalCouponPrice"]];
            switch (i) {
                case 0:
                    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.priceLabel1.text = text;
                    self.subpriceLabel1.text = subText;
                    break;
                case 1:
                    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.priceLabel2.text = text;
                    self.subpriceLabel2.text = subText;
                    break;
                case 2:
                    [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:image]];
                    self.priceLabel3.text = text;
                    self.subpriceLabel3.text = subText;
                    break;
                default:
                    break;
            }
        }
}
@end
