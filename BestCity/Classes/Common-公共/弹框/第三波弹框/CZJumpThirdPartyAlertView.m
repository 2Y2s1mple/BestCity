//
//  CZJumpThirdPartyAlertView.m
//  BestCity
//
//  Created by JsonBourne on 2020/5/12.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZJumpThirdPartyAlertView.h"

@interface CZJumpThirdPartyAlertView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *iconImage;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *subTitle;
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
    // (1京东,2淘宝，4拼多多)
    switch ([self.param[@"source"] integerValue]) {
        case 1:
            self.iconImage.image = [UIImage imageNamed:@"alert-image-4"];
            break;
        case 2:
            self.iconImage.image = [UIImage imageNamed:@"alert-image-3"];
            break;
        case 4:
            self.iconImage.image = [UIImage imageNamed:@"alert-image-5"];
            break;
        default:
            break;
    }
    self.subTitle.text = self.param[@"title"];
}

/** 推出 */
- (IBAction)popAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}




@end
