//
//  CZERecommendViewModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXNetTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZERecommendViewModel : NSObject
/** 全部数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 顶部轮播图数据 */
@property (nonatomic, strong) NSArray *imagesList;
// 根据用户的ID, 修改数据的关注数据
- (void)changeCellModelWithID:(NSString *)ID andIsAttention:(BOOL)isAttention;

/** 获取数据 */
- (void)reloadNewDataSorce:(void (^)(void))block;
- (void)loadMoreDataSorce:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
