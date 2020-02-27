//
//  CZRedPacketsAlertView.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/22.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZRedPacketsAlertView.h"
#import "GXNetTool.h"

@interface CZRedPacketsAlertView ()
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UILabel *hongbaoLabel;
@end

@implementation CZRedPacketsAlertView

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

    self.hongbaoLabel.text = [NSString stringWithFormat:@"%@", self.model[@"addHongbao"]];
    
}

- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)caiBtnAction:(UIButton *)sender {

    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/hongbao/openAll"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool PostNetWithUrl:url body:param bodySytle:GXRequsetStyleBodyHTTP header:nil response:GXResponseStyleJSON success:^(id result) {
         if ([result[@"msg"] isEqualToString:@"success"]) {
             [CZProgressHUD showProgressHUDWithText:@"领取成功"];
             [self dismissViewControllerAnimated:YES completion:nil];
         } else {
             [CZProgressHUD showProgressHUDWithText:result[@"msg"]];
         }
        [CZProgressHUD hideAfterDelay:1.5];
    } failure:nil];
}


@end
