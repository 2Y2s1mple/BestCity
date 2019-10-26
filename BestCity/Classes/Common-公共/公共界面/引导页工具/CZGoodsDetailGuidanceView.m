//
//  CZGoodsDetailGuidanceView.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/25.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZGoodsDetailGuidanceView.h"

@interface CZGoodsDetailGuidanceView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;
@end

@implementation CZGoodsDetailGuidanceView

+ (instancetype)goodsDetailGuidanceView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];;
}

- (IBAction)deleteBtnAction:(id)sender {
    [self removeFromSuperview];
}

@end
