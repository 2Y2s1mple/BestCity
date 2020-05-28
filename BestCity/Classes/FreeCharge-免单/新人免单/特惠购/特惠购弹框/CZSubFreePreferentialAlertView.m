//
//  CZSubFreePreferentialAlertView.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/4.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSubFreePreferentialAlertView.h"

@interface CZSubFreePreferentialAlertView ()

@end

@implementation CZSubFreePreferentialAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
