//
//  CZMemberOfCenterFiveView.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/2.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMemberOfCenterFiveView.h"
#import "UIImageView+WebCache.h"

@interface CZMemberOfCenterFiveView ()
@property (nonatomic, weak) IBOutlet UIImageView *pAvatar;
@property (nonatomic, weak) IBOutlet UIButton *pWechat;
@end

@implementation CZMemberOfCenterFiveView

+ (instancetype)memberOfCenterFiveView
{
    CZMemberOfCenterFiveView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return view;
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
    [self.pAvatar sd_setImageWithURL:[NSURL URLWithString:param[@"pAvatar"]]];
    [self.pWechat setTitle:param[@"pWechat"] forState:UIControlStateNormal];

}

/** 复制到剪切板 */
- (IBAction)generalPaste:(UIButton *)sender
{
    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
    posteboard.string = sender.currentTitle;
    [CZProgressHUD showProgressHUDWithText:@"复制微信成功"];
    [CZProgressHUD hideAfterDelay:1.5];
    [recordSearchTextArray addObject:posteboard.string];
}

@end
