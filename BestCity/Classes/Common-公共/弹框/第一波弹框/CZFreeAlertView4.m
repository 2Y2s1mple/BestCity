//
//  CZFreeAlertView4.m
//  BestCity
//
//  Created by JasonBourne on 2019/11/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFreeAlertView4.h"
#import "GXNetTool.h"

@interface CZFreeAlertView4 ()
@property (nonatomic, strong) UIView *backView;
/** 右边的参数 */
@property (nonatomic, copy) void (^rightBlock)(NSString *);

@property (nonatomic, weak) IBOutlet UITextField *textField;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *titleText;
@end

@implementation CZFreeAlertView4

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}


- (IBAction)btnAction:(UIButton *)sender
{
    if (self.textField.text.length == 0) {
        [CZProgressHUD showProgressHUDWithText:@"请填写邀请码!"];
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
        return;
    }
    
    NSLog(@"%@", self.textField.text);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // 要关注对象ID
    param[@"invitationCode"] = self.textField.text;
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/user/addInvitationCode"];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqualToNumber:@(0)]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:nil];
            });
        }
        [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
        // 取消菊花
        [CZProgressHUD hideAfterDelay:1.5];
        
    } failure:^(NSError *error) {
        // 取消菊花
        [CZProgressHUD hideAfterDelay:0];
    }];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end
