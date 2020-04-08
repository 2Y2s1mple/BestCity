//
//  CZTaoBaoShopVipView.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/7.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZTaoBaoShopVipView.h"
#import "CZMemberOfCenterController.h"
@interface CZTaoBaoShopVipView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation CZTaoBaoShopVipView

+ (instancetype)taoBaoShopVipView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
    self.titleLabel.text = [NSString stringWithFormat:@"升级会员等级，本商品最高可赚￥%.2lf", [param[@"upFee"] floatValue]];

}

- (IBAction)action:(id)sender {
   [CZFreePushTool push_memberOfCenter];
}









@end
