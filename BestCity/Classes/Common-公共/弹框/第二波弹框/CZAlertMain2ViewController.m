//
//  CZAlertMain2ViewController.m
//  BestCity
//
//  Created by JsonBourne on 2020/4/16.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAlertMain2ViewController.h"

@interface CZAlertMain2ViewController ()
/** <#注释#> */
@property (nonatomic, strong) void (^block)(void);
@end

@implementation CZAlertMain2ViewController

- (instancetype)initWithBlock:(void (^)(void))block
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CURRENTVC(currentVc);
    [currentVc dismissViewControllerAnimated:NO completion:^{
        self.block();
    }];
}

@end
