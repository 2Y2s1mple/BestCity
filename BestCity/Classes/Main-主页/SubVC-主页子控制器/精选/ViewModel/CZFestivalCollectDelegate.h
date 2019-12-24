//
//  CZFestivalCollectDataSource.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>
// 数据
#import "CZMainViewSubOneVCModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface CZFestivalCollectDelegate : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (instancetype)initWithCollectView:(UICollectionView *)collectionView;
/** 精选推荐 */
@property (nonatomic, strong) NSMutableArray *qualityGoods;
/** 总数据 */
@property (nonatomic, strong) CZMainViewSubOneVCModel *totalDataModel;

/** 是否是条形布局 */
@property (nonatomic, assign) BOOL layoutType;

/** <#注释#> */
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, weak) UICollectionView *collectionView;


@end

NS_ASSUME_NONNULL_END
