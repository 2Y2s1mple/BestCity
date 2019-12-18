//
//  CZMVSDefaultVCDelegate.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMVSDefaultVCDelegate : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (instancetype)initWithCollectView:(UICollectionView *)collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 广告 */
@property (nonatomic, strong) NSArray *adList;
/** 宫格 */
@property (nonatomic, strong) NSArray *categoryList;
/** 是否是条形布局 */
@property (nonatomic, assign) BOOL layoutType;

@end

NS_ASSUME_NONNULL_END
