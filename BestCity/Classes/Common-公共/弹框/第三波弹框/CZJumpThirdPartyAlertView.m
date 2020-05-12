//
//  CZJumpThirdPartyAlertView.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/12.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZJumpThirdPartyAlertView.h"

@interface CZJumpThirdPartyAlertView ()

@end

@implementation CZJumpThirdPartyAlertView

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



@end
