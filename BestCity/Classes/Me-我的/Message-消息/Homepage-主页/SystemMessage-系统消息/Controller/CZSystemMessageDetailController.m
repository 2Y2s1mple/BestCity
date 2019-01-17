//
//  CZSystemMessageDetailController.m
//  BestCity
//
//  Created by JasonBourne on 2018/8/7.
//  Copyright © 2018年 JasonBourne. All rights reserved.
//

#import "CZSystemMessageDetailController.h"
#import "CZNavigationView.h"
#import "GXNetTool.h"

@interface CZSystemMessageDetailController ()
@end

@implementation CZSystemMessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CZGlobalWhiteBg;
    // 调用已读
    [self messageRead];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:self.model.title rightBtnTitle:nil rightBtnAction:nil navigationViewType:CZNavigationViewTypeBlack];
    [self.view addSubview:navigationView];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = CZGlobalLightGray;
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    backView.x = 10;
    backView.y = 67 + (IsiPhoneX ? 24 : 0) + 10;
    backView.width = SCR_WIDTH - 20;
    
    UILabel *label = [[UILabel alloc] init];
    [backView addSubview:label];
    label.text = self.model.content;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = CZGlobalGray;
    label.numberOfLines = 0;
    label.x = 20;
    label.y = 10;
    label.width = backView.width - 40;
    label.height = [label.text getTextHeightWithRectSize:CGSizeMake(label.width, 10000) andFont:label.font];
    
    backView.height = CZGetY(label) + 10;
    
}


- (void)messageRead
{
    // 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.model.messageUserId;
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"api/message/selectById"];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqual: @"success"]) {
            [CZProgressHUD showProgressHUDWithText:@"已读"];
            [[NSNotificationCenter defaultCenter] postNotificationName:systemMessageDetailControllerMessageRead object:nil];
        }
        [CZProgressHUD hideAfterDelay:1];
    } failure:^(NSError *error) {
    }];
}


@end
