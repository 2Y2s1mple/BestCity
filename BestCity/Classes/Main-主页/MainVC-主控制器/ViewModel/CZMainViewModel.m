//
//  CZMainViewModel.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/11.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZMainViewModel.h"
#import "GXNetTool.h"

@interface CZMainViewModel ()

@end

@implementation CZMainViewModel

#pragma mark - 获取数据
// 刷新时候调用
- (void)getMainTitles:(void (^)(BOOL isFailure))callback
{
    static NSString *key = @"mainTitlesKey";
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/category1"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.mainTitles = result[@"data"];
            [CZSaveTool setObject:self.mainTitles forKey:key];
        }
        callback(YES);
    } failure:^(NSError *error) {
        self.mainTitles = [CZSaveTool objectForKey:key];
        callback(NO);
    }];
}


@end
