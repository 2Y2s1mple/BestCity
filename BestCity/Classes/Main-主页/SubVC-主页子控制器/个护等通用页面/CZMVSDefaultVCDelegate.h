//
//  CZMVSDefaultVCDelegate.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/18.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CZMVSDefaultVCDelegate <NSObject>
@optional
- (void)defaultVCDelegateReload:(NSDictionary *_Nullable)param;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CZMVSDefaultVCDelegate : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (instancetype)initWithCollectView:(UICollectionView *)collectionView;
/** 总数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 广告 */
@property (nonatomic, strong) NSArray *adList;
/** 宫格 */
@property (nonatomic, strong) NSArray *categoryList;
/** 是否是条形布局 */
@property (nonatomic, assign) BOOL layoutType;
/** 埋点代号 */
@property (nonatomic, strong) NSString *statistics;
/** <#注释#> */
@property (nonatomic, assign) id <CZMVSDefaultVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
