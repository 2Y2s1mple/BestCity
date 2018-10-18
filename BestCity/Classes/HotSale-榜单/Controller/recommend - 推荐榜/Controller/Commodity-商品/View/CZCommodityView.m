//
//  CZCommodityView.m
//  BestCity
//
//  Created by JasonBourne on 2018/7/26.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZCommodityView.h"

@interface CZCommodityView ()
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation CZCommodityView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        [self layoutIfNeeded];//写在这里是有问题的, 不换行还好
        self.commodityH = CGRectGetMaxY(self.bottomLabel.frame) + 10;
    }
    return self;
}

@end
