//
//  CZAuthTaobaoAlertView.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/12.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAuthTaobaoAlertView.h"

@interface CZAuthTaobaoAlertView ()
/** <#注释#> */
@property (nonatomic, strong) void (^blcok)(void);
@end

@implementation CZAuthTaobaoAlertView

- (instancetype)initWithAction:(void (^)(void))action
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.blcok = action;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/** 淘宝授权 */
- (IBAction)jipin_authTaobao
{
    [self dismissViewControllerAnimated:NO completion:^{
        self.blcok();
    }];
}


- (IBAction)popAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
