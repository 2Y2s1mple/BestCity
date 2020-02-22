//
//  CZScrollADCell2.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZScrollADCell2.h"
@interface CZScrollADCell2 ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label1;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label2;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *label3;
@end

@implementation CZScrollADCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setParamDic:(NSDictionary *)paramDic
{
    _paramDic = paramDic;
    self.label1.text = [NSString stringWithFormat:@"%@支付宝", paramDic[@"mobile"]];
    self.label2.text = [NSString stringWithFormat:@"提现%@元", paramDic[@"money"]];
    self.label3.text = [NSString stringWithFormat:@"%@分钟前", paramDic[@"time"]];

}

@end
