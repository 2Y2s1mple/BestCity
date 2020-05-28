//
//  CZSub2FreeChargeFooterView.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/25.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSub2FreeChargeFooterView.h"
#import "UIButton+WebCache.h"

@interface CZSub2FreeChargeFooterView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *leftBtn;
@property (nonatomic, weak) IBOutlet UIButton *rightBtn;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@end

@implementation CZSub2FreeChargeFooterView

+ (instancetype)sub2FreeChargeFooterView
{
    CZSub2FreeChargeFooterView *v = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    v.size = CGSizeMake(SCR_WIDTH, 410);
    return v;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(0xFA6D4E);
    self.bottomView.backgroundColor = UIColorFromRGB(0xFA6D4E);
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
    [self.leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.param[@"ad1"][@"img"]] forState:UIControlStateNormal];
    
    [self.rightBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.param[@"ad2"][@"img"]] forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
    [self shape:self.bottomView];
}

/** 复制到剪切板 */
- (IBAction)generalPaste:(id)sender
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = self.param[@"officialWechat"];
    [CZProgressHUD showProgressHUDWithText:@"复制微信成功"];
    [CZProgressHUD hideAfterDelay:1.5];
    [recordSearchTextArray addObject:posteboard.string];
}

/** 左面 */
- (IBAction)leftAction
{
    NSDictionary *dic =  self.param[@"ad1"];
    NSDictionary *param = @{
        @"targetType" : dic[@"type"],
        @"targetId" : dic[@"objectId"],
        @"targetTitle" : dic[@"name"],
    };
    [CZFreePushTool bannerPushToVC:param];
}

/** 右面 */
- (IBAction)rightAction
{
    NSDictionary *dic =  self.param[@"ad2"];
    NSDictionary *param = @{
        @"targetType" : dic[@"type"],
        @"targetId" : dic[@"objectId"],
        @"targetTitle" : dic[@"name"],
    };
    [CZFreePushTool bannerPushToVC:param];
}

- (void)shape:(UIView *)view
{
    CAShapeLayer *border = [CAShapeLayer layer];
       
    //虚线的颜色
    border.strokeColor = UIColorFromRGB(0xFFE2B5).CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    
    border.frame = view.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@8, @8];
    
    [view.layer addSublayer:border];
}

@end
