//
//  CZJIPINStatisticsTool.m
//  BestCity
//
//  Created by JasonBourne on 2020/2/7.
//  Copyright © 2020 JasonBourne. All rights reserved.
//

#import "CZJIPINStatisticsTool.h"
#import "GXNetTool.h"

@implementation CZJIPINStatisticsTool

+ (void)statisticsToolWithID:(NSString *)ID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"eventId"] = ID;
    //获取详情数据
    NSString *urlStr = [JPSERVER_URL stringByAppendingPathComponent:@"api/addEvent"];
    [GXNetTool GetNetWithUrl:urlStr body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"msg"] isEqualToString:@"success"]) {
//            [CZProgressHUD showProgressHUDWithText:[NSString stringWithFormat:@"%@", ID]];
//            [CZProgressHUD hideAfterDelay:1.0];
        }
    } failure:^(NSError *error) {// 结束刷新
    }];
}


@end
