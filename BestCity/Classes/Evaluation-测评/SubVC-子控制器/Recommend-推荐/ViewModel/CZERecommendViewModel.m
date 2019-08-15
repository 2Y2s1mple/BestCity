//
//  CZERecommendViewModel.m
//  BestCity
//
//  Created by JasonBourne on 2019/8/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZERecommendViewModel.h"
#import "CZERecommendItemViewModel.h"
// 模型
#import "CZERecommendModel.h"


@interface CZERecommendViewModel ()
/** 页数 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation CZERecommendViewModel

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - 获取数据
// 刷新时候调用
- (void)reloadNewDataSorce:(void (^)(void))block
{
    self.page = 1;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/recommendList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            //type: 1文章 2推荐关注
            NSMutableArray *dataSource = [NSMutableArray array];
            for (CZERecommendModel *model in [CZERecommendModel objectArrayWithKeyValuesArray:result[@"data"]]) {
                CZERecommendItemViewModel *viewModel = [[CZERecommendItemViewModel alloc] initWithModel:model];

                [dataSource addObject:viewModel];
            }
            self.dataSource = dataSource;
            self.imagesList = result[@"ads"];
            block();
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

// 加载更多时候调用
- (void)loadMoreDataSorce:(void (^)(void))block
{
    self.page++;
    //获取数据
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(self.page);
    [GXNetTool GetNetWithUrl:[JPSERVER_URL stringByAppendingPathComponent:@"api/v2/article/recommendList"] body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"code"] isEqual:@(0)]) {
            for (CZERecommendModel *model in [CZERecommendModel objectArrayWithKeyValuesArray:result[@"data"]]) {
                CZERecommendItemViewModel *viewModel = [[CZERecommendItemViewModel alloc] initWithModel:model];
                [self.dataSource addObject:viewModel];
            }
            block();
        }
        //隐藏菊花
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {}];
}

// 响应cell的刷新数据
- (void)changeCellModelWithID:(NSString *)ID andIsAttention:(BOOL)isAttention
{
    if (isAttention) {
        for (CZERecommendItemViewModel *viewModel in self.dataSource) {
            if (viewModel.model.user.userId == ID) {
                viewModel.model.user.follow = @"1";
            }
        }
    } else {
        for (CZERecommendItemViewModel *viewModel in self.dataSource) {
            if (viewModel.model.user.userId == ID) {
                viewModel.model.user.follow = @"0";
            }
        }
    }
}

@end
