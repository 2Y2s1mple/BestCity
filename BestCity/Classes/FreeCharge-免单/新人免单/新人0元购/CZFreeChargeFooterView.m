//
//  CZFreeChargeFooterView.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/17.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZFreeChargeFooterView.h"

@interface CZFreeChargeFooterView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *btnLabal;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *btnImage;

@end

@implementation CZFreeChargeFooterView

+ (instancetype)freeChargeFooterView
{
    CZFreeChargeFooterView *v = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return v;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 0, SCR_WIDTH - 20, 55) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setIsUpArrow:(BOOL)isUpArrow
{
    _isUpArrow = isUpArrow;
    if (isUpArrow) {
        self.btnLabal.text = @"点击收起";
        self.btnImage.image = [UIImage imageNamed:@"list-right-5"];
    } else {
        self.btnLabal.text = @"展开更多";
        self.btnImage.image = [UIImage imageNamed:@"list-right-4"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.block();
}

@end
