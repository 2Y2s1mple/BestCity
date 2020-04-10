//
//  CZMemberOfCenterFourView.m
//  BestCity
//
//  Created by JasonBourne on 2020/4/2.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZMemberOfCenterFourView.h"
#import "GXNetTool.h"
#import "CZMemberOfCenterTool.h"

@interface CZMemberOfCenterFourView ()
/** 升级vip */
@property (nonatomic, weak) IBOutlet UIButton *upgradeBtn;
/** backView */
@property (nonatomic, weak) IBOutlet UIView *backView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *title1;
@property (nonatomic, weak) IBOutlet UILabel *subTitle1;
@property (weak, nonatomic) IBOutlet UIProgressView *progress1;
@property (nonatomic, weak) IBOutlet UILabel *title2;
@property (nonatomic, weak) IBOutlet UILabel *subTitle2;
@property (weak, nonatomic) IBOutlet UIProgressView *progress2;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIImageView *vipImageView;
@end

@implementation CZMemberOfCenterFourView
+ (instancetype)memberOfCenterFourView
{
    CZMemberOfCenterFourView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    view.height = CZGetY(view.backView);
    return view;
}

- (void)setParam:(NSDictionary *)param
{
    _param = param;
    self.vipImageView.image = [CZMemberOfCenterTool toolUserStatus:param][3];
    self.title1.text = [NSString stringWithFormat:@"邀请有效直属粉丝%@人", param[@"levelInvitedUserCount"]];
    self.subTitle1.text = [NSString stringWithFormat:@"%@/%@人", param[@"invitedUserCount"], param[@"levelInvitedUserCount"]];

   CGFloat scale1 = [param[@"invitedUserCount"] floatValue] / [param[@"levelInvitedUserCount"] floatValue];

    [self.progress1 setProgress:scale1 animated:YES];


    self.title2.text = [NSString stringWithFormat:@"近30天淘宝结算佣金%@元", param[@"levelCommission"]];
    self.subTitle2.text = [NSString stringWithFormat:@"%@/%@元", param[@"commission"], param[@"levelCommission"]];

    CGFloat scale2 = [param[@"commission"] floatValue] / [param[@"levelCommission"] floatValue];

    [self.progress2 setProgress:scale2 animated:YES];

    [self.upgradeBtn setTitle:[CZMemberOfCenterTool toolUserStatus:param][2] forState:UIControlStateNormal];

}

/** 申请升级 */
- (IBAction)ApplyUpgrade:(UIButton *)sender
{
    // 最高等级
    if ([self.param[@"level"] integerValue] == 2) {
        [CZProgressHUD showProgressHUDWithText:@"已为最高等级"];
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    
    if ([self isUpgrade]) {
        // 符合条件
        if ([self.param[@"levelStatus"] integerValue] == 0) {
            [CZProgressHUD showProgressHUDWithText:@"您的申请正在审核中，请耐心等待"];
            [CZProgressHUD hideAfterDelay:1.5];
        } else {
            [self upgrade];
        }
    } else {
        // 不符合条件
        if ([self.param[@"levelStatus"] integerValue] == 0) {
            [CZProgressHUD showProgressHUDWithText:@"您的申请正在审核中，请耐心等待"];
            [CZProgressHUD hideAfterDelay:1.5];
        } else {
            [CZProgressHUD showProgressHUDWithText:@"您还未完成任务，请继续努力"];
            [CZProgressHUD hideAfterDelay:1.5];
        }
    }
}

- (void)upgrade
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/levelUpdate"];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];

        [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
            if ([result[@"code"] isEqual:@(0)]) {

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"升级申请提交成功" message:[NSString stringWithFormat:@"请添加您的导师微信：%@", self.param[@"pWechat"]] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIPasteboard *posteboard = [UIPasteboard generalPasteboard];
                    posteboard.string = self.param[@"pWechat"];
                    [recordSearchTextArray addObject:posteboard.string];
                }]];
                [[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alert animated:NO completion:nil];
            } else {

            }

        } failure:nil];
}

- (BOOL)isUpgrade
{
    if ([self.param[@"invitedUserCount"] floatValue] >= [self.param[@"levelInvitedUserCount"] floatValue] && [self.param[@"commission"] floatValue] >= [self.param[@"levelCommission"] floatValue]) {
        return YES;
    } else {
        return NO;
    }
        
}


@end
