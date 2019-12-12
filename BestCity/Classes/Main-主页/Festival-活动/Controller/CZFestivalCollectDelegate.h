//
//  CZFestivalCollectDataSource.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface CZFestivalCollectDelegate : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (instancetype)initWithCollectView:(UICollectionView *)collectionView;
/** <#注释#> */

@end

NS_ASSUME_NONNULL_END
