//
//  CZETestViewModel.m
//  BestCity
//
//  Created by JasonBourne on 2019/10/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZETestViewModel.h"
#import "GXNetTool.h"


@interface CZETestViewModel ()
/** <#注释#> */
@property (nonatomic, assign) NSInteger page;
@end

@implementation CZETestViewModel
#pragma mark - 获取数据
- (void)reloadNewTrailDataSorce:(void (^)(NSDictionary *))successData
{
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"evaluationType"] = @(1);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/evaluationList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            self.dataSource = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];

            for (CZETestModel *model in self.dataSource) {
                model.isRead = [model.articleReadData[@"clickCount"] integerValue] > 0;
            }

            !successData ? : successData(result);
        }
    } failure:^(NSError *error) {}];
}

- (void)loadMoreTrailDataSorce:(void (^)(NSDictionary *))successData
{
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"evaluationType"] = @(1);
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/evaluationList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
           NSArray *list = [CZETestModel objectArrayWithKeyValuesArray:result[@"data"]];
            for (CZETestModel *model in list) {
                model.isRead = [model.articleReadData[@"clickCount"] integerValue] > 0;
            }
            [self.dataSource addObjectsFromArray:list];
        }
        !successData ? : successData(result);
    } failure:^(NSError *error) {}];
}

@end
