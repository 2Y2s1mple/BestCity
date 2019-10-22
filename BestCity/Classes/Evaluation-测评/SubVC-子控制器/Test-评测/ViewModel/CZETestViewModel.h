//
//  CZETestViewModel.h
//  BestCity
//
//  Created by JasonBourne on 2019/10/21.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZETestModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CZETestViewModel : NSObject
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
- (void)reloadNewTrailDataSorce:(void (^)(void))successData;
- (void)loadMoreTrailDataSorce:(void (^)(void))successData;
@end

NS_ASSUME_NONNULL_END
