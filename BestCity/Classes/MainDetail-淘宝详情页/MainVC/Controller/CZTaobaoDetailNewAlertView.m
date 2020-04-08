//
//  CZTaobaoDetailNewAlertView.m
//  BestCity
//
//  Created by JasonBourne on 2020/3/6.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZTaobaoDetailNewAlertView.h"

@interface CZTaobaoDetailNewAlertView ()

@end

@implementation CZTaobaoDetailNewAlertView

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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
