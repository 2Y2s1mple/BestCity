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
- (void)getMainTitles:(void (^)(void))callback
{
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/tbk/category1"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            NSArray *titleList = result[@"data"];
            self.mainTitles = [NSMutableArray array];
            for (NSDictionary *dic in titleList) {
                [self.mainTitles addObject:dic[@"categoryName"]];
            }
        }
        callback();
    } failure:^(NSError *error) {

    }];
}


@end
