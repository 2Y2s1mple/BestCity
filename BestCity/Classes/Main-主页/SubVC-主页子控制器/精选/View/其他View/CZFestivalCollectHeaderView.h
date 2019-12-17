//
//  CZFestivalCollectHeaderView.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZFestivalCollectHeaderView : UICollectionReusableView
/** 轮播图 */
@property (nonatomic, strong) NSArray *ad1List;
/** 宫格图 */
@property (nonatomic, strong) NSArray *boxList;

@end

NS_ASSUME_NONNULL_END
