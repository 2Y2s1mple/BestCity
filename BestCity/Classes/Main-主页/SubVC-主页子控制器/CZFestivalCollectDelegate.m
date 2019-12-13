//
//  CZFestivalCollectDataSource.m
//  BestCity
//
//  Created by JasonBourne on 2019/12/12.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "CZFestivalCollectDelegate.h"

#import "CZFestivalCollectHeaderView.h"

#import "CZFestivalCollectOneCell.h" // 新人0元购
#import "CZFestivalCollectTwoCell.h" // 热销
#import "CZFestivalCollectThreeCell.h" // 按钮

@implementation CZFestivalCollectDelegate
static NSString *ID = @"CZFestivalCollectCell";
static NSString *HeaderId = @"CZFestivalCollectheader";
static NSString *oneId = @"CZFestivalCollectOneCell";
static NSString *twoId = @"CZFestivalCollectTwoCell";
static NSString *threeId = @"CZFestivalCollectThreeCell";

- (instancetype)initWithCollectView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];

        [collectionView registerClass:[CZFestivalCollectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderId];

        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZFestivalCollectOneCell class]) bundle:nil] forCellWithReuseIdentifier:oneId];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZFestivalCollectTwoCell class]) bundle:nil] forCellWithReuseIdentifier:twoId];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZFestivalCollectThreeCell class]) bundle:nil] forCellWithReuseIdentifier:threeId];


        collectionView.dataSource = self;
        collectionView.delegate = self;
    }
    return self;
}



// <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) { // 新人0元购
        CZFestivalCollectOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneId forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) { // 爆款
        CZFestivalCollectTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:twoId forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) { // 按钮
           CZFestivalCollectThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:threeId forIndexPath:indexPath];
           return cell;
    } else if (indexPath.section == 3) { // 做过了 横排
           CZFestivalCollectOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneId forIndexPath:indexPath];
           return cell;
    } else if (indexPath.section == 4) { // 做过了 竖排
        CZFestivalCollectOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneId forIndexPath:indexPath];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.backgroundColor = RANDOMCOLOR;
        return cell;
    }
}


// <UICollectionViewDelegateFlowLayout>
// 头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        CZFestivalCollectHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderId forIndexPath:indexPath];

        return headerView;
    } else {
        return nil;
    }



    if (kind == UICollectionElementKindSectionHeader) {
        
    } else {

    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(SCR_WIDTH, 573);
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCR_WIDTH, 270);
    } else if (indexPath.section == 2) {
        return CGSizeMake(SCR_WIDTH, 89);
    } else {
        return CGSizeZero;
    }
}


// 头视图的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, 270);
    } else {
        return CGSizeZero;
    }
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.item);
}


@end
