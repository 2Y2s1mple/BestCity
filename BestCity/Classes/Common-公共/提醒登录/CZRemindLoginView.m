//
//  CZRemindLoginView.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/23.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZRemindLoginView.h"

@interface CZRemindLoginView ()
/** 一共多少秒 */
@property (nonatomic, assign) NSInteger secondsCount;
/** <#注释#> */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) IBOutlet UILabel *day1;
@property (nonatomic, weak) IBOutlet UILabel *day2;

@property (nonatomic, weak) IBOutlet UILabel *hours1;
@property (nonatomic, weak) IBOutlet UILabel *hours2;

@property (nonatomic, weak) IBOutlet UILabel *minutes1;
@property (nonatomic, weak) IBOutlet UILabel *minutes2;

@property (nonatomic, weak) IBOutlet UILabel *seconds1;
@property (nonatomic, weak) IBOutlet UILabel *seconds2;
@end

@implementation CZRemindLoginView

+ (instancetype)remindLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.secondsCount = 30 * 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)setupTimer
{
    
    
    // 秒
    NSString *seconds1 = [NSString stringWithFormat:@"%.2ld", (self.secondsCount % 60)];
    self.seconds1.text = seconds1;


    // 分
    NSString *minutes1 = [NSString stringWithFormat:@"%.2ld", (self.secondsCount / 60 % 60)];
    self.minutes2.text = minutes1;

    // 时

    NSString *hours1 = [NSString stringWithFormat:@"%.2ld", (self.secondsCount / 60 / 60 % 24)];
    self.hours1.text = @"00";

    // 天
     NSString *day1 = [NSString stringWithFormat:@"%.2ld", (self.secondsCount / 60 / 60 / 24)];
    self.day1.text = [day1 substringToIndex:1];
    self.day2.text = [day1 substringFromIndex:1];
    
    
    if (self.secondsCount == 0) {
        [self.timer invalidate];
    }

    self.secondsCount--;
}

- (void)dealloc
{
    [self.timer invalidate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     if ([JPTOKEN length] <= 0)
       {
           CZLoginController *vc = [CZLoginController shareLoginController];
           [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:vc animated:NO completion:^{
               UITabBarController *tabbar = (UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
               UINavigationController *nav = tabbar.selectedViewController;
               UIViewController *currentVc = nav.topViewController;
               [currentVc.navigationController popViewControllerAnimated:nil];
           }];
           return;
       }
}


+ (instancetype)remindLoginView2
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

@end
