//
//  CZAlertView4Controller.m
//  BestCity
//
//  Created by JasonBourne on 2020/1/9.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZAlertView4Controller.h"
#import "UIImageView+WebCache.h"
#import "GXNetTool.h"

@interface CZAlertView4Controller ()
/** 图像 */
@property (nonatomic, weak) IBOutlet UIImageView *bigImageView;
/** 名字 */
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
/** 附标题 */
@property (nonatomic, weak) IBOutlet UILabel *subTitleLabel;
@end

@implementation CZAlertView4Controller
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = self.param[@"data"][@"data"];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]]];
    self.nameLabel.text = dic[@"nickname"];

    NSString *subText = [NSString stringWithFormat:@"%@积币", self.param[@"addPoint"]];
    NSString *text = [self.subTitleLabel.text stringByAppendingString:subText];
    self.subTitleLabel.attributedText = [text addAttributeColor:UIColorFromRGB(0xE25838) Range:[text rangeOfString:subText]];

}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)invitationAction:(id)sender {
    [self action5];
}
//邀请码
- (void)action5
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"invitationCode"] = self.param[@"data"][@"data"][@"invitationCode"];
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/addInvitationCode"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            
        }
        [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];

}


@end
