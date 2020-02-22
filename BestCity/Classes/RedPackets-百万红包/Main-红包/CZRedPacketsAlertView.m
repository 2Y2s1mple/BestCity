//
//  CZRedPacketsAlertView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsAlertView.h"

@interface CZRedPacketsAlertView ()

@end

@implementation CZRedPacketsAlertView

- (instancetype)init {
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
    [self dismissViewControllerAnimated:YES completion:nil];



}


@end
