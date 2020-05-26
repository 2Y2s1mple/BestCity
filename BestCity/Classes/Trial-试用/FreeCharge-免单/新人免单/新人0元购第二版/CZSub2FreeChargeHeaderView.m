//
//  CZSub2FreeChargeHeaderView.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/25.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSub2FreeChargeHeaderView.h"
@interface CZSub2FreeChargeHeaderView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *bottomView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel1;
/** <#注释#> */
@property (nonatomic, strong) NSTimer *timer;
/** <#注释#> */
@property (nonatomic, assign) NSInteger count;
@end

@implementation CZSub2FreeChargeHeaderView

+ (instancetype)sub2FreeChargeHeaderView
{
    CZSub2FreeChargeHeaderView *v = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    v.size = CGSizeMake(SCR_WIDTH, 385);
    return v;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(0xFA6D4E);
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.param[@"endTime"] doubleValue]];
    
    NSDate *courrentDate = [NSDate date];
    
    NSTimeInterval interval = [date timeIntervalSinceDate:courrentDate];
    self.count = interval;
    
    if (self.count > 0) {
        self.timeLabel.hidden = NO;
        self.timeLabel1.hidden = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    } else {
        self.timeLabel.hidden = YES;
        self.timeLabel1.hidden = NO;
    }
    
    
    
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

- (void)timeDown
{
    self.count--;
    NSInteger second = self.count % 60;
    
    NSInteger minute = self.count / 60 % 60;
    
    NSInteger hour = self.count / 60 / 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld后将失效", hour, minute, second];
}
@end
