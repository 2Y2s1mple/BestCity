//
//  CZSub2FreeChargeAlertController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSub2FreeChargeAlertController.h"
#import "UIImageView+WebCache.h"

@interface CZSub2FreeChargeAlertController ()
/** <#注释#> */
@property (nonatomic, strong) NSTimer *timer;
/** <#注释#> */
@property (nonatomic, assign) NSInteger count;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet UIImageView *imageView3;
@end

@implementation CZSub2FreeChargeAlertController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.param[@"endTime"] doubleValue]];
    
    NSDate *courrentDate = [NSDate date];
    
    NSTimeInterval interval = [date timeIntervalSinceDate:courrentDate];
    self.count = interval;

   if (self.count > 0) {
        self.timeLabel.hidden = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    } else {
        self.timeLabel.hidden = YES;
    }
    
    NSArray *list = self.param[@"data"];

    for (int i = 0; i < list.count; i++) {
        switch (i) {
            case 1:
            {
                NSDictionary *dic = list[i];
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
                break;
            }
            case 2:
            {
                NSDictionary *dic = list[i];
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
                break;
            }
            case 3:
            {
                NSDictionary *dic = list[i];
                [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
                break;
            }
            default:
                break;
        }
    }
}

- (void)timeDown
{
    self.count--;
    NSInteger second = self.count % 60;
    
    NSInteger minute = self.count / 60 % 60;
    
    NSInteger hour = self.count / 60 / 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld后将失效", hour, minute, second];
}


- (IBAction)pop:(id)sender {
    if ([self.presentingViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)self.presentingViewController;
        UINavigationController *nav = tabbar.selectedViewController;
        [self dismissViewControllerAnimated:NO completion:^{
            [nav popViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end
