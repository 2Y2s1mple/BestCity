//
//  CZAlertView2Controller.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/8.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAlertView2Controller.h"
#import "UIImageView+WebCache.h"

@interface CZAlertView2Controller ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;
@property (nonatomic, weak) IBOutlet UIImageView *imageView3;
@end

@implementation CZAlertView2Controller
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *list = self.param[@"newAllowanceGoodsList"];

    for (int i = 0; i < list.count; i++) {

        switch (i) {
            case 2:
            {
                NSDictionary *dic = list[i];
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
                break;
            }
            case 3:
            {
                NSDictionary *dic = list[i];
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
                break;
            }
            case 4:
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

- (IBAction)pop:(id)sender {
    if ([self.presentingViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)self.presentingViewController;
        UINavigationController *nav = tabbar.selectedViewController;

        [nav popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
   
}


@end
