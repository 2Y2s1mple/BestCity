//
//  CZEAttentionViewModel.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZEAttentionViewModel.h"
#import "CZEAttentionItemViewModel.h"

@interface CZEAttentionViewModel ()
/** 页数 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation CZEAttentionViewModel
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

+ (void)initialize
{
    if (self == [CZEAttentionViewModel class]) {
        [CZEAttentionModel setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"userList" : @"CZEAttentionUserModel"
                     };
        }];
    }
}

#pragma mark - 获取数据
// 刷新时候调用
- (void)reloadNewDataSorce:(void (^)(NSDictionary *))block
{
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/myfollowList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            //type: 1文章 2推荐关注
            NSMutableArray *dataSource = [NSMutableArray array];
            for (CZEAttentionModel *model in [CZEAttentionModel objectArrayWithKeyValuesArray:result[@"data"]]) {
                model.isRead = [model.article[@"articleReadData"][@"clickCount"] integerValue] > 0;
                CZEAttentionItemViewModel *viewModel = [[CZEAttentionItemViewModel alloc] initWithAttentionModel:model];
                viewModel.isShowAttention = [result[@"follow"] boolValue];
                [dataSource addObject:viewModel];
            }
            self.dataSource = dataSource;
            block(result);
        }
    } failure:^(NSError *error) {

    }];
}

// 加载更多时候调用
- (void)loadMoreDataSorce:(void (^)(NSDictionary *))block
{
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/myfollowList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            for (CZEAttentionModel *model in [CZEAttentionModel objectArrayWithKeyValuesArray:result[@"data"]]) {
                model.isRead = [model.article[@"articleReadData"][@"clickCount"] integerValue] > 0;
                CZEAttentionItemViewModel *viewModel = [[CZEAttentionItemViewModel alloc] initWithAttentionModel:model];
                viewModel.isShowAttention = [result[@"follow"] boolValue];

                [self.dataSource addObject:viewModel];
            }
            block(result);
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {

    }];
}

@end
