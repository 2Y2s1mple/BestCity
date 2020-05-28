//
//  CZSub3FreeChargeAlertController.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/27.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZSub3FreeChargeAlertController.h"
#import "CZRedPackets2Controller.h"

@interface CZSub3FreeChargeAlertController ()

@end

@implementation CZSub3FreeChargeAlertController
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

- (IBAction)pushVC:(id)sender {
    CURRENTVC(currentVc);
    CZRedPackets2Controller *vc = [[CZRedPackets2Controller alloc] init];
    [currentVc.navigationController pushViewController:vc animated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
