//
//  CZUpdataView.m
//  BestCity
//
//  Created by JasonBourne on 2019/3/16.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZUpdataView.h"
@interface CZUpdataView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *chengeContent;
@end

@implementation CZUpdataView
+ (instancetype)updataView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0] ;
}


/** <#注释#> */
- (IBAction)gotoUpdata
{
    //跳转到App Store
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app//id1450707933?mt=8"]];
}

/** <#注释#> */
- (IBAction)deleteView
{
    [self removeFromSuperview];
}

- (void)setVersionMessage:(NSDictionary *)versionMessage
{
    _versionMessage = versionMessage;
    self.versionLabel.text = versionMessage[@"versionName"];
    self.chengeContent.text = versionMessage[@"content"];
}

@end
