//
//  CZAlertMainViewController.m
//  BestCity
//
//  Created by JsonBourne on 2020/4/16.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAlertMainViewController.h"
#import "CZAlertMain2ViewController.h"

@interface CZAlertMainViewController ()
/** <#注释#> */
@property (nonatomic, strong) void (^block)(void);
@end

@implementation CZAlertMainViewController

- (instancetype)initWithBlock:(void (^)(void))block
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.block = block;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *alert = [[UIView alloc] init];
    alert.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    alert.size = CGSizeMake(SCR_WIDTH, (IsiPhoneX ? 44 : 20));
    [self.view addSubview:alert];
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:^{
        self.block();
    }];
}

/** 跳第二个图片 */
- (IBAction)jumpImageview
{
    CZAlertMain2ViewController *imageView2 = [[CZAlertMain2ViewController alloc] initWithBlock:self.block];
    [self presentViewController:imageView2 animated:NO completion:nil];
    
}


@end
