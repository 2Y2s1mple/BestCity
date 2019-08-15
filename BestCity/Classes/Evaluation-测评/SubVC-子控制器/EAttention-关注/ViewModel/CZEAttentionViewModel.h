//
//  CZEAttentionViewModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/7.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXNetTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZEAttentionViewModel : NSObject
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
// 方法
- (void)reloadNewDataSorce:(void (^)(void))block;
- (void)loadMoreDataSorce:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
