//
//  CZScrollAD.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/20.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GXScrollAD;

NS_ASSUME_NONNULL_BEGIN
@protocol CZScrollADDelegate <NSObject>
@optional
- (void)cz_scrollAD:(GXScrollAD *)scrollAD didSelectItemAtIndex:(NSInteger)index;
- (void)cz_scrollAD:(GXScrollAD *)scrollAD currentItemAtIndex:(NSInteger)index;
@end

@interface GXScrollAD : UIView

@property (nonatomic, weak) id <CZScrollADDelegate> delegate;

/** 通过注册CollectionCell方式无线滚动 */
- (instancetype)initWithFrame:(CGRect)frame dataSourceList:(NSArray *)dataSourceList scrollerConfig:(void (^)(GXScrollAD *maker))configBlock registerCell:(void (^)(UICollectionView *))registerCellBlock scrollADCell:(UICollectionViewCell * (^)(UICollectionView *collectionView, NSIndexPath *indexPath))scrollADBlock;

/** 数据 */
@property (nonatomic, strong) NSArray *dataSourceList;

/** 设置轮播图的时间间隔: 默认3.0s */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/** 滚动方向:默认水平 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/** 自动滚动: 默认是YES */
@property (nonatomic, assign) BOOL isAutoScroll;

/** 显示pageView: 默认是隐藏 */
@property (nonatomic, assign) BOOL isShowPageView;

/** 点击调用 */
@property (nonatomic, strong) void (^selectedIndexBlock)(NSInteger index);

/** 当前index */
@property (nonatomic, strong) void (^currentIndexBlock)(NSInteger index);

/** 刷新 */
- (void)reloadDataSource;

@end

NS_ASSUME_NONNULL_END

