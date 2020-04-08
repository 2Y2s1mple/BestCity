//
//  CZMemberOfCenterOneView.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/1.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMemberOfCenterOneView.h"
#import "CZInvitationController.h"

@interface CZMemberOfCenterOneView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIButton *popBtn;
@end

@implementation CZMemberOfCenterOneView

+ (instancetype)memberOfCenterOneView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

/** 邀请好友 */
- (IBAction)inviteFriend
{
    [CZFreePushTool push_inviteFriend];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)setIsNavPush:(BOOL)isNavPush
{
    _isNavPush = isNavPush;
    if (self.isNavPush) { // 是新开页面
        self.popBtn.hidden = NO; // 显示
    } else {
        self.popBtn.hidden = YES;
    }
}

- (IBAction)popAction:(UIButton *)sender {
    // 隐藏菊花
    [CZProgressHUD hideAfterDelay:0];
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)nextResponder;
            [vc dismissViewControllerAnimated:YES completion:nil];
            [vc.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
}


@end
