//
//  CZAlertView1Controller.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/8.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAlertView1Controller.h"
#import "CZSubFreeChargeController.h"

@interface CZAlertView1Controller ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *caiBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *caiBtnBottomMargin;

/** 背景图片 */
@property (nonatomic, weak) IBOutlet UIImageView *backImageView;

@end

@implementation CZAlertView1Controller
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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)caiBtnAction:(UIButton *)sender {
//    if (sender.selected) {
        CZSubFreeChargeController *vc = [[CZSubFreeChargeController alloc] init];
        UITabBarController *tabbar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nav = tabbar.selectedViewController;
        [nav pushViewController:vc animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        self.backImageView.image = [UIImage imageNamed:@"alert-9"];
//        [self.caiBtn setImage:[UIImage imageNamed:@"alert-4"] forState:UIControlStateNormal];
//        self.caiBtnBottomMargin.constant = 100;
//        sender.selected = YES;
//    }
}

@end
